class CreateUserInstitutions < ActiveRecord::Migration[7.0]
  def change
    create_table :user_institutions, id: :uuid do |t|
      t.references :user, :institution, type: :uuid
      t.timestamps
    end

    add_index :user_institutions, [:user_id, :institution_id], unique: true
  end
end
