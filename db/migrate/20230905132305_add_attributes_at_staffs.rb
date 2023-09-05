class AddAttributesAtStaffs < ActiveRecord::Migration[7.0]
  def change
    add_column :staffs, :first_name, :string
    add_column :staffs, :last_name, :string
    add_column :staffs, :phone_number, :string
    add_column :staffs, :avatar_data, :text
  end
end
