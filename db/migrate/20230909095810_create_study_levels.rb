class CreateStudyLevels < ActiveRecord::Migration[7.0]
  def change
    create_table :study_levels, id: :uuid do |t|
      t.string :name
      t.timestamps
    end
  end
end
