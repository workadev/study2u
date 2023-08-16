class AddResetPasswordToDevices < ActiveRecord::Migration[7.0]
  def change
    add_column :devices, :reset_password, :boolean, default: false
  end
end
