class JsonWebToken
  def self.encode(payload, secret_key=nil)
    secret_key_base = secret_key.blank? ? Rails.application.secrets.secret_key_base : secret_key
    JWT.encode(payload, secret_key_base)
  end

  def self.decode(token, secret_key=nil)
    secret_key_base = secret_key.blank? ? Rails.application.secrets.secret_key_base : secret_key
    return HashWithIndifferentAccess.new(JWT.decode(token, secret_key_base)[0])
  rescue
    nil
  end
end
