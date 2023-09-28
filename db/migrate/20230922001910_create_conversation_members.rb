class CreateConversationMembers < ActiveRecord::Migration[7.0]
  def change
    create_table :conversation_members, id: :uuid do |t|
      t.references :conversation, type: :uuid
      t.string :last_read, :status
      t.boolean :online, default: false
      t.integer :unread
      t.timestamps
    end
  end
end
