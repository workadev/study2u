# == Schema Information
#
# Table name: messages
#
#  id              :uuid             not null, primary key
#  attachment_data :text
#  message_type    :string
#  read            :boolean          default(FALSE)
#  text            :text
#  timetoken       :string
#  userable_type   :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  conversation_id :uuid
#  parent_id       :uuid
#  userable_id     :uuid
#
# Indexes
#
#  index_messages_on_conversation_id                (conversation_id)
#  index_messages_on_parent_id                      (parent_id)
#  index_messages_on_userable_type_and_userable_id  (userable_type,userable_id)
#
class Message < ApplicationRecord
  ACTION_ALLOWED = ["create", "update", "delete", "read", "read_all"]
  MESSAGE_TYPE = ["text", "attachment"]
  add_scope_and_check_method(constants: MESSAGE_TYPE, field_name: "message_type")

  attr_accessor :action, :read_timetoken, :attachment_id, :_destroy

  include Conversationable
  include Uploadable
  include Broadcastable
  include ImageUploader.attachment(:attachment)

  belongs_to :conversation
  belongs_to :userable, polymorphic: true
  belongs_to :user, class_name: "User", foreign_key: "userable_id", optional: true
  belongs_to :staff, class_name: "Staff", foreign_key: "userable_id", optional: true
  belongs_to :parent, class_name: "Message", optional: true

  has_many :childrens, class_name: "Message", foreign_key: "parent_id"

  before_validation :set_timetoken
  before_validation :set_message_type

  validates_uniqueness_of :timetoken, scope: :conversation_id
  validates_inclusion_of :action, in: ACTION_ALLOWED, allow_nil: true
  validates_inclusion_of :message_type, in: MESSAGE_TYPE
  validate :message_content

  after_commit :set_conversation_member, on: :create

  def message_content
    if is_text?
      errors.add(:base, "message text is required") if text.blank?
    elsif is_attachment?
      errors.add(:base, "attachment is required") if attachment.blank?
    end
  end

  # 'from' ordering from oldest to newest
  # 'start' ordering from newest to oldest
  def self.list_chats(conversation_id:, opt:{})
    by_conversation_id = Message.joins(:conversation)
      .where(conversation_id: conversation_id)
      .order("messages.timetoken DESC")
      .group("messages.id")
    by_conversation_id = by_conversation_id.reorder("messages.timetoken ASC") if opt[:from].present?

    timetoken_start = opt[:start] || opt[:from]
    start_operator, end_operator = get_start_and_end_operator(timetoken_start: timetoken_start, opt: opt)

    messages = by_conversation_id
    messages = messages.where("timetoken #{start_operator} ?", timetoken_start).order("messages.timetoken DESC") if timetoken_start.present?
    messages = messages.where("timetoken #{end_operator} ?", opt[:end]) if opt[:end].present?
    messages = messages.where("text ilike ?", "%#{opt[:text]}%") if opt[:text].present?
    messages = messages.where("message_type = ?", opt[:message_type]) if opt[:message_type].present?

    if opt[:limit].present?
      messages = messages.limit(opt[:limit])
      start_operator = "<=" if start_operator.blank?
      next_timetoken = by_conversation_id.where("timetoken #{start_operator.gsub("=", "")} ?", messages.last.timetoken).first&.timetoken if messages.present?
    end

    return messages, next_timetoken
  end

  def self.get_start_and_end_operator(timetoken_start:, opt: {})
    start_operator = opt[:start].present? ? "<=" : ">=" if timetoken_start.present?
    end_operator = opt[:from].present? ? "<=" : ">=" if opt[:end].present?

    return start_operator, end_operator
  end

  def self.perform_action(parameter:)
    unless ["create"].include?(parameter["action"])
      message = find_message(parameter: parameter)

      if parameter["userable_type"] == "User"
        user = User.find_by_id(parameter["userable_id"])
      elsif parameter["userable_type"] == "Staff"
        user = Staff.find_by_id(parameter["userable_id"])
      end

      ErrorChannel.broadcast_to(
        user,
        ErrorChannel.default_broadcast_payload.merge({
          error: "Message not found",
          action_type: parameter["action"],
          object_name: "message"
        })
      ) if message.blank? && user.present?
    end

    case parameter["action"]
    when "create"
      message = new(parameter.except("id"))
      message.lock!
      message.execute_action(action: "save!", action_type: parameter["action"])
      other_member = ConversationMember.where("conversation_id = ? AND userable_type != ? AND userable_type != ?", message.conversation_id, message.userable_type, message.userable_id).first
      message.push_notif(conversation_member: other_member) if other_member.present?
    when "update"
      if message.present?
        message.lock!
        message.assign_attributes(parameter)
        message.execute_action(action: "save!", action_type: parameter["action"])
      end
    when "delete"
      message.action = "delete"
      message.execute_action(action: "destroy!", action_type: parameter["action"]) if message.present?
    when "read", "read_all"
      message.read_timetoken = parameter["read_timetoken"]
      message.perform_read(userable_type: parameter["userable_type"], userable_id: parameter["userable_id"])
    end
  end

  def self.find_message(parameter:)
    userable_id = parameter["userable_id"]
    userable_type = parameter["userable_type"]
    action = parameter["action"]

    if (ACTION_ALLOWED-["create", "read_all"]).include?(action)
      operator = "="
      find_by = "id::text"
      value = parameter["id"]
      if action.eql?("read")
        operator = "!="
        find_by = "timetoken"
        value = parameter["read_timetoken"]
      end

      if value.present?
        message = Message.where("#{find_by} = ?", value)
        message = message.where("userable_id::text #{operator} ? AND userable_type #{operator} ?", userable_id, userable_type)
      end
    elsif action.eql?("read_all")
      message = Message.where("conversation_id = ? AND userable_id != ? AND userable_type != ?", parameter["conversation_id"], userable_id, userable_type).order("timetoken DESC")
    end

    return message&.first
  end

  def push_notif(conversation_member:)
    OneSignal::Api.new.push(opt: { body: push_notif_payload(send_to: conversation_member.userable_id) })
  end

  def perform_read(userable_type:, userable_id:)
    latest_read = read_all_by(latest_timetoken: read_timetoken, userable_id: userable_id, userable_type: userable_type)
    latest_timetoken = read_timetoken.blank? ? latest_read : read_timetoken
    unread_count = update_unread_and_last_read(latest_timetoken: latest_timetoken, userable_id: userable_id, userable_type: userable_type)
    ChatChannel.broadcast_to(
      conversation_id,
      ChatChannel.default_broadcast_payload.merge({
        action: "read",
        last_read: latest_timetoken,
        unread: unread_count,
        conversation_id: conversation_id,
        userable_id: userable_id,
        userable_type: userable_type
      })
    )
  end

  def read_all_by(latest_timetoken:, userable_id:, userable_type:)
    messages = Message.where(conversation_id: conversation_id).where("userable_id != ? AND userable_type != ? AND read = ?", userable_id, userable_type, false).order("timetoken")
    messages.lock!
    messages = messages.where("timetoken <= ?", latest_timetoken) if latest_timetoken.present?
    latest_message = messages.last.try(:timetoken)
    messages.update_all(read: true)
    return latest_message
  end

  def update_unread_and_last_read(latest_timetoken:, userable_id:, userable_type:)
    my_member = ConversationMember.where("conversation_id = ? AND userable_id = ? AND userable_type = ?", conversation_id, userable_id, userable_type).first

    if my_member.present?
      if (my_member.last_read.nil? || my_member.last_read.to_i < latest_timetoken.to_i)
        unread_count = Message.where(conversation_id: conversation_id).where("userable_id != ? AND userable_type != ? AND read = ?", userable_id, userable_type, false)
        unread_count = unread_count.where("timetoken > ?", latest_timetoken) if latest_timetoken.present?
        unread_count = unread_count.count
        my_member.lock!
        my_member.update(unread: unread_count, last_read: latest_timetoken)
      end
    end

    return unread_count || 0
  end

  private

  def push_notif_payload(send_to:)
    if attachment.present?
      title = "#{userable.name} sent you an attachment"
      content = "Tap to chat with #{userable.name}"
    elsif text.present?
      title = "New Message!"
      content = "#{userable.name} sent you new message"
    end

    avatar_url = userable.avatar_url
    avatar_url = avatar_url.try(:split, "?").try(:first) if avatar_url.present?
    {
      include_external_user_ids: [send_to],
      headings: { en: title },
      contents: { en: content },
      data: {
        channel: conversation_id,
        sender_id: userable_id,
        sender_type: userable_type,
        click_action: "new_message",
        user_avatar: avatar_url,
        sender_name: userable.name
      }
    }
  end

  def set_timetoken
    self.timetoken = "#{(Time.now.utc.to_f * 10000000).to_i}#{rand(1000)}".to_i if new_record? && self.timetoken.blank?
  end

  def set_message_type
    if new_record? || (text_changed? || attachment_changed?)
      self.message_type = attachment.present? ? "attachment" : "text"
    end
  end

  def set_conversation_member
    conversation_members = ConversationMember.where("conversation_id = ? AND userable_id != ? AND userable_type != ?", self.conversation_id, self.userable_id, self.userable_type)
    conversation_members.update_all('unread = coalesce(unread, 0)+1')
  end
end
