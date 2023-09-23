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
class ConversationMember < ApplicationRecord
  STATUS = ["active", "inactive"]
  add_scope_and_check_method(constants: STATUS, field_name: "status")

  belongs_to :conversation
  belongs_to :userable, polymorphic: true
  belongs_to :user, class_name: "User", foreign_key: "userable_id", optional: true
  belongs_to :staff, class_name: "Staff", foreign_key: "userable_id", optional: true

  has_one :last_message, through: :conversation

  validates_uniqueness_of :conversation_id, scope: [:userable_id, :userable_type], message: "already exists"
  validates_inclusion_of :status, in: STATUS

  before_validation :set_status
end
