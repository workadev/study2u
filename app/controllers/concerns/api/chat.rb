module Api::Chat
  include Api::User

  extend ActiveSupport::Concern

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
end
