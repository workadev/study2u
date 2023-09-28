class ChatChannel < ApplicationCable::Channel
  def subscribed
    update_presence(online: true)
    stream_from "chat:#{params[:conversation_id]}"
  end

  def receive(data)
    if params[:conversation_id].blank?
      reject_unauthorized_connection
    else
      is_member_of_conversations
      message_params = message_data(data: data)
      if message_params.present? && Message::ACTION_ALLOWED.include?(message_params["action"])
        Message.perform_action(parameter: message_params)
      else
        ErrorChannel.broadcast_to(
          current_user,
          ErrorChannel.default_broadcast_payload.merge({
            error: "Params 'action' is invalid, valid values are: #{Message::ACTION_ALLOWED.split(" or ")}",
            action_type: "invalid",
            object_name: "message"
          })
        )
      end
    end
  end

  def unsubscribed
    update_presence(online: false)
    stop_stream_from "chat:#{params[:conversation_id]}"
  end

  private

  def update_presence(online:)
    is_member_of_conversations
    @member.update(online: online)
  end

  def is_member_of_conversations
    @member = conversation_member
    return reject_unauthorized_connection if @member.blank?
  end

  def conversation_member
    ConversationMember.find_by_conversation_id_and_userable_id_and_userable_type(params[:conversation_id], current_user.id, current_user.class.name)
  end

  def message_data(data:)
    begin
      ActionController::Parameters.new(data).require(:message).permit(:id, :text, :attachment_id, :action, :read_timetoken, :parent_id, :_destroy).merge({ conversation_id: params[:conversation_id], userable_id: current_user.id, userable_type: current_user.class.name })
    rescue ActionController::ParameterMissing => e
      {}
    end
  end
end
