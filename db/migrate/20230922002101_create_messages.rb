class CreateMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :messages, id: :uuid do |t|
      t.references :conversation, :parent, :user, type: :uuid
      t.text :attachment_data, :text
      t.string :message_type, :timetoken
      t.boolean :read, default: false
      t.timestamps
    end
  end
end
