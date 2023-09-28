# == Schema Information
#
# Table name: conversation_members
#
#  id              :uuid             not null, primary key
#  last_read       :string
#  online          :boolean          default(FALSE)
#  status          :string
#  unread          :integer
#  userable_type   :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  conversation_id :uuid
#  userable_id     :uuid
#
# Indexes
#
#  index_conversation_members_on_conversation_id                (conversation_id)
#  index_conversation_members_on_userable_type_and_userable_id  (userable_type,userable_id)
#
class ChatResource < BaseResource
  root_key :chat, :chats

  one :last_message, resource: MessageResource

  attributes :id, :conversation_id, :unread, :last_read, :online, :status

  attribute :user do |resource|
    Oj.load("#{resource.userable_type}Resource".constantize.new(resource.userable, params: { user_type: resource.userable_type }).serialize)["#{resource.userable_type.downcase}"]
  end
end
