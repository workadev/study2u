class Api::V1::SubscriptionsController < ApiController
  def create
    @object = Subscription.find_or_initialize_by(object_params)

    if @object.save
      set_response(data: get_resource(object: @object), message: "Success create subscription", status: 201)
    else
      set_response(message: @object.errors.full_messages.join(", "), status: 400)
    end
  end

  private

  def object_params
    begin
      params.require(:subscription).permit(:email)
    rescue ActionController::ParameterMissing => e
      return {}
    end
  end
end
