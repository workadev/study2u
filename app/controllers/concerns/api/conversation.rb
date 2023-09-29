module Api::Conversation
  include Api::Chat

  extend ActiveSupport::Concern

  included do
    before_action :set_index, only: :index
    before_action :check_conversation, only: :show
    before_action :check_member, only: :show
    before_action :set_resource, only: :show
    before_action :find_user, only: :create
  end

  def set_index
    @query = Conversation.list_channels(userable_id: user.id, userable_type: user.class.name, search: params[:search])
    @object_name = "chats"
    @resource_name = ChatResource
  end

  def create
    @conversation = Conversation.init_conversation(sender: user, recipient: @user)

    if @conversation.present?
      set_resource
      set_response(data: get_resource(object: @object), message: "Success connect to #{@user.class_name}", status: 201)
    else
      set_response(message: "Something went wrong", status: 500)
    end
  end

  private

  def find_user
    id = params[:user_id] || params[:staff_id]
    object = user_or_staff.to_s == "User" ? Staff : User
    @user = object.find_by_id(id)
    return set_response(message: "#{object.to_s} not found", status: 404) if @user.blank?
  end

  def set_resource
    @resource_name = ChatResource
    @object = Conversation.response_channels(channels: [@conversation], conversation_members: @conversation.conversation_members.as_json, userable_id: user.id, userable_type: user.class.name).first
  end
end
