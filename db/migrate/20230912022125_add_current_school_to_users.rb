class AddCurrentSchoolToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :current_school, :string
  end
end
