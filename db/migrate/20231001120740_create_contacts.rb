class CreateContacts < ActiveRecord::Migration[7.0]
  def change
    create_table :contacts, id: :uuid do |t|
      t.string :name, :email, :message
      t.timestamps
    end
  end
end
