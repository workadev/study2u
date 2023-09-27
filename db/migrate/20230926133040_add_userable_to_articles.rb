class AddUserableToArticles < ActiveRecord::Migration[7.0]
  def change
    add_column :articles, :userable_type, :string
    add_column :articles, :userable_id, :uuid
    add_index :articles, [:userable_id, :userable_type]
  end
end
