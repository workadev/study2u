class TypingChannel < ApplicationCable::Channel
  def subscribed
    stream_for current_user
  end

  def receive(data)
    conversation = Conversation.find_by(id: data["conversation_id"])

    if conversation.present?
      relation_name = current_user.class_name == "user" ? "staffs" : "users"
      chat_with = conversation.send(relation_name).where.not(id: current_user.id).last
    end

    if conversation.present? && chat_with.present?
      TypingChannel.broadcast_to chat_with, { type: "typing", payload: payload(data: data) }
    else
      TypingChannel.broadcast_to current_user, { message: "Conversation not found" }
    end
  end

  def unsubscribed
    stop_stream_for current_user
  end

  private

  def payload(data:)
    {
      user_id: current_user.id,
      name: current_user.name,
      typing: data["typing"],
      conversation_id: data["conversation_id"]
    }
  end
end
