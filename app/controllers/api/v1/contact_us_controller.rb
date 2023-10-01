class Api::V1::ContactUsController < ApiController
  def create
    @object = Contact.find_or_initialize_by(object_params)

    if @object.save
      set_response(data: get_resource(object: @object), message: "Success send email", status: 201)
    else
      set_response(message: @object.errors.full_messages.join(", "), status: 400)
    end
  end

  private

  def object_params
    begin
      params.require(:contact).permit(:name, :email, :message)
    rescue ActionController::ParameterMissing => e
      return {}
    end
  end
end
