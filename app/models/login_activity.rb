# == Schema Information
#
# Table name: login_activities
#
#  id             :uuid             not null, primary key
#  city           :string
#  context        :string
#  country        :string
#  failure_reason :string
#  identity       :string
#  ip             :string
#  latitude       :float
#  longitude      :float
#  referrer       :text
#  region         :string
#  scope          :string
#  strategy       :string
#  success        :boolean
#  user_agent     :text
#  user_type      :string
#  created_at     :datetime
#  user_id        :uuid
#
# Indexes
#
#  index_login_activities_on_identity  (identity)
#  index_login_activities_on_ip        (ip)
#  index_login_activities_on_user      (user_type,user_id)
#
class LoginActivity < ApplicationRecord
  belongs_to :user, polymorphic: true, optional: true

  has_many :devices

  def user_agent_object
    DeviceDetector.new(user_agent)
  end

  def name
    user_agent_object.name
  end

  def full_version
    user_agent_object.full_version
  end

  def os_name
    user_agent_object.os_name
  end

  def os_full_version
    user_agent_object.os_full_version
  end

  def device_name
    user_agent_object.device_name
  end

  def device_type
    user_agent_object.device_type
  end
end
