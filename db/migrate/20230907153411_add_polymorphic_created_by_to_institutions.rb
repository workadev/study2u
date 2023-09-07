class AddPolymorphicCreatedByToInstitutions < ActiveRecord::Migration[7.0]
  def change
    add_column :institutions, :created_by_id, :uuid
    add_column :institutions, :created_by_type, :string
  end
end
