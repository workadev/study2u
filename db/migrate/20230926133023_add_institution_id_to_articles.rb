class AddInstitutionIdToArticles < ActiveRecord::Migration[7.0]
  def change
    add_reference :articles, :institution, type: :uuid
  end
end
