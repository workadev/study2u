module Jwtable
  extend ActiveSupport::Concern

  def encode_token(mac_address:, reset_password: false)
    device = Device.init(deviceable: self, mac_address: mac_address, reset_password: reset_password)
    time_now = Time.now
    exp_access_token = time_now + 1.day
    exp_refresh_token = time_now + 1.week
    encoding_value = { "#{self.class_name}_id": id, device_id: device.id }
    access_token = jwt_encode(encoding_value: encoding_value, iat: time_now.to_i, exp: exp_access_token.to_i)
    refresh_token = jwt_encode(encoding_value: encoding_value.merge({ is_refresh_token: true, refresh_token_uuid: device.refresh_token }), iat: time_now.to_i, exp: exp_refresh_token.to_i)

    resource_params = self.class.name == "User" ? { include: ["users.interests"] } : {}
    {
      user: Oj.load("::#{self.class.name}Resource".constantize.new(self, params: resource_params).serialize),
      token: access_token,
      expired: exp_access_token,
      refresh_token: refresh_token,
      expired_refresh_token: exp_refresh_token,
      scope: device.scope
    }
  end

  def jwt_encode(encoding_value:, iat: nil, exp: nil)
    time_now = Time.now
    iat = time_now.to_i if iat.blank?
    exp = (iat + 1.weeks).to_i if exp.blank? #default 1 weeks if exp is blank
    JsonWebToken.encode(encoding_value.merge({ iat: iat, exp: exp }))
  end
end
