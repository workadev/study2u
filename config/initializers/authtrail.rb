# set to true for geocoding (and add the geocoder gem to your Gemfile)
# we recommend configuring local geocoding as well
# see https://github.com/ankane/authtrail#geocoding
AuthTrail.geocode = true
AuthTrail.job_queue = :low_priority

# AuthTrail.identity_method = lambda do |request, opts, user|
#   identity = request.params.dig(opts[:scope], :email) || request.params.dig(opts[:scope], :phone_number)
#   identity = request.params[:phone_number] || request.params[:phone_number] if identity.blank?

#   if user.is_a?(User)
#     identity = user.try(:phone_number) || user.try(:email) if identity.blank?
#     mac_address = request.headers["mac-address"]
#     device = user.devices.where(mac_address: mac_address) if mac_address.present?
#     { authentication: identity, device: device, user: user }
#   else
#     identity
#   end
# end

# AuthTrail.track_method = lambda do |info|
#   identity = info[:identity]

#   if identity.present?
#     unless info[:user].is_a?(Administrator)
#       info.delete(:identity)
#       info[:identity] = identity.try(:[], :authentication) rescue identity
#       info[:user] = identity.try(:[], :user) rescue nil
#     end

#     act = LoginActivity.create(info)

#     device = identity.try(:[], :device) rescue nil
#     identity[:device].first.update(login_activity_id: act.try(:id)) if info[:user].is_a?(User) && device.present?
#     AuthTrail::GeocodeJob.new(act).perform_now
#   end
# end

# add or modify data
# AuthTrail.transform_method = lambda do |data, request|
#   data[:request_id] = request.request_id
# end

# exclude certain attempts from tracking
# AuthTrail.exclude_method = lambda do |data|
#   data[:identity] == "capybara@example.org"
# end
