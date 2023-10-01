# == Schema Information
#
# Table name: conversations
#
#  id                      :uuid             not null, primary key
#  last_message_updated_at :datetime
#  status                  :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  last_message_id         :uuid
#
# Indexes
#
#  index_conversations_on_last_message_id  (last_message_id)
#
class Conversation < ApplicationRecord
  STATUS = ["active", "inactive"]
  add_scope_and_check_method(constants: STATUS, field_name: "status")

  belongs_to :last_message, class_name: "Message", foreign_key: "last_message_id", optional: true

  has_many :messages, dependent: :destroy
  has_many :conversation_members, dependent: :destroy
  has_many :users, through: :conversation_members, source: :user
  has_many :staffs, through: :conversation_members, source: :staff

  accepts_nested_attributes_for :conversation_members, allow_destroy: true

  validates_inclusion_of :status, in: STATUS

  before_validation :set_status
  before_save :set_last_message_updated_at

  def set_status
    self.status = "active" if self.status.blank?
  end

  def set_last_message_updated_at
    if new_record?
      self.last_message_updated_at = self.created_at || Time.now.utc if self.last_message_updated_at.blank?
    end
  end

  def self.init_conversation(sender:, recipient:)
    conversation = direct_conversation(sender: sender, recipient: recipient)

    if conversation.blank?
      conversation_members_attributes = ([
        { userable_id: sender.id, userable_type: sender.class.name, status: "active" },
        { userable_id: recipient.id, userable_type: recipient.class.name, status: "active" }
      ])

      conversation = Conversation.create(status: "active", conversation_members_attributes: conversation_members_attributes)
    else
      conversation = conversation.first
    end

    return conversation
  end

  def self.direct_conversation(sender:, recipient:)
    Conversation.joins(:conversation_members)
      .where("conversation_members.userable_id::text IN (?)",
        [sender.id, recipient.id]
      )
      .group(:id)
      .having("count(*) = 2")
  end

  def self.list_channels(userable_id:, userable_type:, search: nil)
    channels = Conversation.my_channels(userable_id: userable_id, userable_type: userable_type)

    conversation_members = ConversationMember.left_joins(conversation: :messages)
      .where("conversation_members.conversation_id IN (?)", channels.map(&:id))
      .group("conversation_members.id")

    conversation_members = conversation_members.joins("LEFT OUTER JOIN users ON conversation_members.userable_id = users.id AND conversation_members.userable_type = 'User' AND users.id != '#{userable_id}'")
      .joins("LEFT OUTER JOIN staffs ON conversation_members.userable_id = staffs.id AND conversation_members.userable_type = 'Staff' AND staffs.id != '#{userable_id}'")
      .where("(users.first_name ILIKE ? OR users.last_name ILIKE ? OR staffs.first_name ILIKE ? OR staffs.last_name ILIKE ?) OR conversation_members.userable_id = ? AND conversation_members.userable_type = ?", "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%", userable_id, userable_type) if search.present?

    response_channels(channels: channels, conversation_members: conversation_members.as_json, userable_id: userable_id, userable_type: userable_type)
  end

  def self.my_channels(userable_id:, userable_type:)
    Conversation.joins(:conversation_members)
      .where("conversation_members.userable_id = ? AND conversation_members.userable_type = ?", userable_id, userable_type)
      .where("conversations.status = ? AND conversation_members.status = ?", "active", "active")
      .group("conversations.id")
      .order("MAX(conversations.last_message_updated_at) DESC")
  end

  def self.response_channels(channels:, conversation_members:, userable_id:, userable_type:)
    members = []

    if channels.present? && conversation_members.present?
      other_members_in_array_of_hash = conversation_members.select { |member| member["userable_id"] != userable_id && member["userable_type"] != userable_type  }
      other_members_class_name = other_members_in_array_of_hash.first["userable_type"]
      other_members = other_members_class_name.constantize.where("id in (?)", other_members_in_array_of_hash.map { |hash| hash["userable_id"]})
      channels.each do |channel|
        begin
          members_by_conversation_id = conversation_members.select { |member| member["conversation_id"] == channel.id }

          if members_by_conversation_id.present?
            my_member = members_by_conversation_id.find { |member| member["userable_id"] == userable_id && member["userable_type"] == userable_type }.except("userable_id")
            other_member = members_by_conversation_id.find { |member| member["userable_id"] != userable_id && member["userable_type"] != userable_type  }

            if my_member.present? && other_member.present?
              conversation_member = ConversationMember.new(my_member)
              conversation_member.userable = other_members.select { |member| member.id == other_member["userable_id"] }.first
              conversation_member.userable_id = other_member["userable_id"]
              conversation_member.userable_type = other_member["userable_type"]
              conversation_member.created_at = channel.created_at
              conversation_member.updated_at = channel.last_message_updated_at || channel.updated_at
              members.push(conversation_member)
            end
          end
        rescue StandardError => e
          members = []
          break
        end
      end
    end

    return members
  end
end
