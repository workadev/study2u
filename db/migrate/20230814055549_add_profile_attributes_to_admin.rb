class AddProfileAttributesToAdmin < ActiveRecord::Migration[7.0]
  def change
    add_column :admins, :name, :string
    add_column :admins, :contact_no, :string
    add_column :admins, :avatar_data, :text
  end
end
