class CreateConversations < ActiveRecord::Migration[7.0]
  def change
    create_table :conversations, id: :uuid do |t|
      t.references :last_message, type: :uuid
      t.datetime :last_message_updated_at
      t.string :status
      t.timestamps
    end
  end
end
