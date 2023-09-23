class TypingChannel < ApplicationCable::Channel
  def subscribed
    stream_for current_user
  end

  def receive(data)
    conversation = Conversation.find_by(id: data["conversation_id"])
    chat_with = conversation.users.where.not(id: current_user.id).last if conversation.present?

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
