class IsStaffToActionsAndRoles < ActiveRecord::Migration[7.0]
  def change
    add_column :actions, :is_staff, :boolean, default: false
    add_column :roles, :is_staff, :boolean, default: false
  end
end
