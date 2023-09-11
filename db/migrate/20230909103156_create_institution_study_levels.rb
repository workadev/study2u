class CreateInstitutionStudyLevels < ActiveRecord::Migration[7.0]
  def change
    create_table :institution_study_levels, id: :uuid do |t|
      t.references :study_level, :institution, type: :uuid
      t.timestamps
    end

    add_index :institution_study_levels, [:study_level_id, :institution_id], unique: :true, name: "institution_study_level_institution"
  end
end
