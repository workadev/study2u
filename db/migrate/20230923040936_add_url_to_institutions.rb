class AddUrlToInstitutions < ActiveRecord::Migration[7.0]
  def change
    add_column :institutions, :url, :string
  end
end
