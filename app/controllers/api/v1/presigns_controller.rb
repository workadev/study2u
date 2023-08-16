class Api::V1::PresignsController < ApiController
  def new
    # return set_response(message: "Page not found", status: 404) if Rails.env.development? || Rails.env.test?
    set_rack_response ImageUploader.presign_response(:cache, request.env)
  end

  private

  def set_rack_response((status, headers, body))
    self.status = status
    self.headers.merge!(headers)
    self.response_body = body
  end
end
