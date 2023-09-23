# == Schema Information
#
# Table name: devices
#
#  id                :uuid             not null, primary key
#  app_version       :string
#  deviceable_type   :string
#  mac_address       :string
#  online            :boolean
#  platform          :string
#  refresh_token     :string
#  reset_password    :boolean          default(FALSE)
#  status            :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  deviceable_id     :uuid
#  login_activity_id :uuid
#
# Indexes
#
#  index_devices_on_deviceable_id_and_deviceable_type  (deviceable_id,deviceable_type)
#  index_devices_on_login_activity_id                  (login_activity_id)
#
class Device < ApplicationRecord
  STATUS = ["active", "signout"]
  add_scope_and_check_method(constants: STATUS, field_name: "status")

  belongs_to :deviceable, polymorphic: true

  validates_presence_of :mac_address
  validates_uniqueness_of :mac_address, scope: [:deviceable_type, :deviceable_id], case_sensitive: false, allow_nil: true
  validates_inclusion_of :status, in: STATUS

  before_validation :set_status, if: :new_record?

  scope :active, -> { where(status: "active") }

  def self.init(deviceable:, mac_address:, reset_password: false)
    device = find_by(deviceable_type: deviceable.class.name, deviceable_id: deviceable.id, mac_address: mac_address) || new
    device.deviceable = deviceable
    device.mac_address = mac_address
    device.status = "active"
    device.refresh_token = SecureRandom.uuid unless device.refresh_token?
    device.reset_password = reset_password
    device.save
    return device
  end

  def scope
    self.id.split("-").join("").to_sym
  end

  private

  def set_status
    self.status = "active" if self.status.blank?
  end
end
