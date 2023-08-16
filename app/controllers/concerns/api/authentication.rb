module Api::Authentication
  extend ActiveSupport::Concern

  RESPONSE_HEADER = [:token, :refresh_token, :expired, :expired_refresh_token, :external_user_id]

  def authenticate_request!
    scope = request_path[2] == "users" ? User : Staff
    return not_authorized unless user_id_in_token?
    scope_name = scope.to_s.underscore.downcase
    instance_variable_set "@current_#{scope_name}".to_sym, scope.where("id::text = ?", auth_token[:user_id]).first
    @current_device = Device.where("id::text = ? AND status = ?", auth_token[:device_id], "active").first
    refresh_token_endpoint = (path_last == "sessions" && params[:action] == "refresh_token")
    reset_password_endpoint = (path_last == "reset_passwords" && params[:action] == "update")
    conditions = [
      instance_variable_get("@current_#{scope_name}").blank? || current_device.blank?,
      auth_token[:is_refresh_token].blank? && !reset_password_endpoint && @current_device.try(:reset_password),
      auth_token[:is_refresh_token].present? && !refresh_token_endpoint,
      auth_token[:is_refresh_token].blank? && refresh_token_endpoint,
      auth_token[:is_refresh_token].present? && refresh_token_endpoint && auth_token[:refresh_token_uuid] != @current_device.try(:refresh_token)
    ]
    return not_authorized if conditions.any?(true)
  rescue JWT::VerificationError, JWT::DecodeError
    return not_authorized
  end

  def http_token
    @http_token ||= if request.headers["Authorization"].present?
      request.headers["Authorization"].split(" ").last
    end
  end

  def auth_token
    @auth_token ||= JsonWebToken.decode(http_token)
  end

  def user_id_in_token?
    user_id = auth_token[:user_id].present? || auth_token[:staff_id].present? if auth_token.present?
    http_token && auth_token && user_id && auth_token[:device_id].present?
  end

  def set_response(data: nil, message: "", status: 200, opt: {})
    if @no_content
      head :no_content
    else
      default_response = { message: message, status: status }
      default_response = Hash[:title, opt[:title]].merge!(default_response) if opt[:title].present?
      default_response = default_response.merge({ data: data }) if data.present?
      render json: default_response, status: status
    end
  end

  def not_authorized
    set_response(message: "Not Authorized", status: 401)
  end

  def check_mac_address
    set_response(message: "Parameter mac-address in header required", status: 400) if request.headers['mac-address'].blank?
  end

  def authorize(mac_address: nil, reset_password: false)
    user = @user || try(:current_user) || try(:current_staff)
    if user.present?
      is_sign_in = mac_address.blank?
      mac_address = is_sign_in ? request.headers['mac-address'] : mac_address
      payload = user.encode_token(mac_address: mac_address, reset_password: reset_password)
      RESPONSE_HEADER.map { |header_name| response.set_header(header_name.to_s, payload[header_name]) }
      sign_in(payload[:scope], user) if is_sign_in
      return payload[:user]
    end
  end
end
