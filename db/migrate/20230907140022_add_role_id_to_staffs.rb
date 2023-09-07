class AddRoleIdToStaffs < ActiveRecord::Migration[7.0]
  def change
    add_reference :staffs, :role, type: :uuid
  end
end
