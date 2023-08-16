class CreateActions < ActiveRecord::Migration[7.0]
  def change
    create_table :actions, id: :uuid do |t|
      t.references :category, type: :uuid
      t.string :action_key, :name, :description
      t.timestamps
    end
    add_index :actions, :action_key, unique: true
  end
end
