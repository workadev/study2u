class AddAttributesToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :headline, :string
    add_column :users, :about_me, :text
    add_column :users, :phone_number, :string
    add_column :users, :address, :string
    add_column :users, :birthday, :date
    add_column :users, :avatar_data, :text
  end
end
