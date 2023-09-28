class AddOnlineAndLastOnlineAt < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :online, :boolean
    add_column :users, :last_online_at, :datetime
    add_column :devices, :online, :boolean
  end
end
