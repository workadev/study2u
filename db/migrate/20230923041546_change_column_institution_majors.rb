class ChangeColumnInstitutionMajors < ActiveRecord::Migration[7.0]
  def change
    remove_column :institution_majors, :intake
    add_column :institution_majors, :intake, :string, array: true
  end
end
