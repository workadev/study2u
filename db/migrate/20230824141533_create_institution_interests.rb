class CreateInstitutionInterests < ActiveRecord::Migration[7.0]
  def change
    create_table :institution_interests, id: :uuid do |t|
      t.references :institution, :interest
      t.timestamps
    end

    add_index :institution_interests, [:institution_id, :interest_id], unique: true
  end
end
