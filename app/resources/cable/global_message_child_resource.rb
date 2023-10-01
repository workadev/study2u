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
class Cable::GlobalMessageChildResource < Cable::GlobalMessageResource
  root_key :message, :messages

  one :parent, resource: "Cable::GlobalMessageParentResource"
end
