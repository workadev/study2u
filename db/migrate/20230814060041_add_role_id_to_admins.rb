class AddRoleIdToAdmins < ActiveRecord::Migration[7.0]
  def change
    add_reference :admins, :role, type: :uuid
  end
end
