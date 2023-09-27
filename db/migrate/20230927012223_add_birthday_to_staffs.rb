class AddBirthdayToStaffs < ActiveRecord::Migration[7.0]
  def change
    add_column :staffs, :birthday, :date
  end
end
