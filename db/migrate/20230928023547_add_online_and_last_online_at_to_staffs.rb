class AddOnlineAndLastOnlineAtToStaffs < ActiveRecord::Migration[7.0]
  def change
    add_column :staffs, :online, :boolean, default: false
    add_column :staffs, :last_online_at, :datetime
  end
end
