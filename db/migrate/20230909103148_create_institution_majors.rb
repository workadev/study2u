class CreateInstitutionMajors < ActiveRecord::Migration[7.0]
  def change
    create_table :institution_majors, id: :uuid do |t|
      t.references :major, :institution, type: :uuid
      t.timestamps
    end

    add_index :institution_majors, [:major_id, :institution_id], unique: :true
  end
end
