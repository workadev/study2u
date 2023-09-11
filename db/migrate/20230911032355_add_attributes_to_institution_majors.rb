class AddAttributesToInstitutionMajors < ActiveRecord::Migration[7.0]
  def change
    add_column :institution_majors, :intake, :string
    add_column :institution_majors, :fee, :integer
    add_column :institution_majors, :duration_normal, :string
    add_column :institution_majors, :duration_extra, :string
  end
end
