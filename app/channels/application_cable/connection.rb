module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user, :current_device

    def connect
      self.current_user, self.current_device = find_verified
    end

    private

    def find_verified
      decode = JsonWebToken.decode(base64[:token]) if base64.present? && base64[:token].present?

      user = User.where("id::text = ?", decode[:user_id]).first if decode.present? && decode[:user_id].present?
      user = Staff.where("id::text = ?", decode[:staff_id]).first if user.blank? && decode.present? && decode[:staff_id].present?

      device_id = decode[:device_id] if decode.present?
      device = Device.where("id::text = ? and status = ?", device_id, "active").first if device_id.present?

      user.present? && device.present? ? [user, device] : reject_unauthorized_connection
    end

    def base64
      return nil unless request.params[:token].present?
      begin
        decoded = Base64.decode64(request.params[:token])
        data = JSON.parse(decoded, symbolize_names: true)
      rescue StandardError => e
        nil
      end
    end
  end
end
