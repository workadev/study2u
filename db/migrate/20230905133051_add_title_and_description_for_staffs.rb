class AddTitleAndDescriptionForStaffs < ActiveRecord::Migration[7.0]
  def change
    add_column :staffs, :title, :string
    add_column :staffs, :description, :string
  end
end
