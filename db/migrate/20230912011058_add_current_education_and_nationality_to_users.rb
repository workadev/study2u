class AddCurrentEducationAndNationalityToUsers < ActiveRecord::Migration[7.0]
  def change
    add_reference :users, :current_education, type: :uuid
    add_column :users, :nationality, :string
  end
end
