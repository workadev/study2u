class AddReferenceUserToConversationMembers < ActiveRecord::Migration[7.0]
  def change
    add_reference :conversation_members, :user, type: :uuid
  end
end
