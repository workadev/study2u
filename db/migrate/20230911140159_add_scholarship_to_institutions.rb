class AddScholarshipToInstitutions < ActiveRecord::Migration[7.0]
  def change
    add_column :institutions, :scholarship, :boolean, default: false
    add_column :institutions, :phone_number, :string
  end
end
