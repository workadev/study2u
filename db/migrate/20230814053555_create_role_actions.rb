class CreateRoleActions < ActiveRecord::Migration[7.0]
  def change
    create_table :role_actions, id: :uuid do |t|
      t.references :role, :action, type: :uuid
      t.timestamps
    end
    # add_index :role_actions, :role_id
    # add_index :role_actions, :action_id
  end
end
