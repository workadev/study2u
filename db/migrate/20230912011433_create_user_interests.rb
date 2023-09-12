class CreateUserInterests < ActiveRecord::Migration[7.0]
  def change
    create_table :user_interests, id: :uuid do |t|
      t.references :user, :interest, type: :uuid
      t.timestamps
    end

    add_index :user_interests, [:user_id, :interest_id], unique: true
  end
end
