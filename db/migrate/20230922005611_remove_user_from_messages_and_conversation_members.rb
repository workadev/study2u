class RemoveUserFromMessagesAndConversationMembers < ActiveRecord::Migration[7.0]
  def change
    remove_column :messages, :user_id
    remove_column :conversation_members, :user_id
    add_column :messages, :userable_type, :string
    add_column :messages, :userable_id, :uuid
    add_index :messages, [:userable_type, :userable_id]
    add_column :conversation_members, :userable_type, :string
    add_column :conversation_members, :userable_id, :uuid
    add_index :conversation_members, [:userable_type, :userable_id]
  end
end
