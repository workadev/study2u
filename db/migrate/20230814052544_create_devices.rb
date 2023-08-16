class CreateDevices < ActiveRecord::Migration[7.0]
  def change
    create_table :devices, id: :uuid do |t|
      t.references :login_activity, type: :uuid
      t.string :app_version, :mac_address, :platform, :refresh_token, :status, :deviceable_type
      t.uuid :deviceable_id
      t.timestamps
    end

    add_index :devices, [:deviceable_id, :deviceable_type]
  end
end
