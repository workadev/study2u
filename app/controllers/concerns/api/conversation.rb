module Api::Conversation
  extend ActiveSupport::Concern

  def user
    current_user || current_staff
  end

  def check_conversation
    find_conversation unless @conversation.present?
    return if @conversation.blank?
    return set_response(message: "This conversation is not active", status: 400) if @conversation.present? && @conversation.status != "active"
  end

  def check_member
    find_conversation_member unless @conversation_member.present?
    return if @conversation.blank?
    return set_response(message: "You're not part of this conversations", status: 403) if @conversation_member.blank?
  end

  def find_conversation_member
    find_conversation unless @conversation.present?
    @conversation_member = ConversationMember.find_by_conversation_id_and_userable_id_and_userable_type(@conversation.id, user.id, user.class.name) if @conversation.present?
  end

  def find_object
    conversation_id = params[:id] || params[:conversation_id]
    @conversation = Conversation.find_by_id(conversation_id)
    return set_response(message: "Conversation not found", status: 404) if @conversation.blank?
  end

  def set_index_conversations
    @query = Conversation.list_channels(userable_id: user.id, userable_type: user.class.name)
    @object_name = "chats"
    @resource_name = ChatResource
  end

  def set_index_messages
    error, @query, next_timetoken = Message.list_chats(
      conversation_id: conversation_id,
      opt: { from: params[:from], start: params[:start], end: params[:end], limit: params[:limit], text: params[:text], message_type: params[:message_type] }
    )
    @query = @query.includes(parent: :user, :user)
    @object_name = "messages"

    header_key = params[:start].present? || params[:end].present? || params[:limit].present? ? "next_start" : params[:from].present? ? "next_from" : nil
    response.set_header(header_key, next_timetoken) if header_key.present?
    @resource_name = "Message::ChildResource"
  end
end
