module Api::Message
  include Api::Chat

  extend ActiveSupport::Concern

  included do
    before_action :find_object
    before_action :check_conversation
    before_action :check_member
    before_action :set_index
  end

  def set_index
    @query, next_timetoken = Message.list_chats(
      conversation_id: @conversation.id,
      opt: { from: params[:from], start: params[:start], end: params[:end], limit: params[:limit], text: params[:text], message_type: params[:message_type], latest_deleted_timetoken: @conversation_member&.latest_deleted_timetoken }
    )
    @query = @query.includes(:userable, parent: :userable)
    @object_name = "messages"

    header_key = params[:start].present? || params[:end].present? || params[:limit].present? ? "next_start" : params[:from].present? ? "next_from" : nil
    response.set_header(header_key, next_timetoken) if header_key.present?
    @resource_name = "Message::ChildResource"
  end
end
