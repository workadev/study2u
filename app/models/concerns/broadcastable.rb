module Broadcastable
  extend ActiveSupport::Concern

  def execute_action(action:, action_type:, type: nil)
    begin
      if send(action)
        payload = ChatChannel.default_broadcast_payload.merge(cable_message_response).merge({ action: type })
        ChatChannel.broadcast_to(
          conversation_id,
          payload
        )
      else
        ErrorChannel.broadcast_to(
          user,
          ErrorChannel.default_broadcast_payload.merge(
            cable_message_response.merge(
              {
                error: errors.messages,
                action_type: action_type,
                object_name: "message"
              }
            )
          )
        )
      end
    rescue StandardError => e
      ErrorChannel.broadcast_to(
        user,
        ErrorChannel.default_broadcast_payload.merge(
          cable_message_response.merge(
            {
              error: e.message,
              action_type: action_type,
              object_name: "message"
            }
          )
        )
      )
    end
  end

  def cable_message_response
    Oj.load("Cable::#{self.class.name.split("::").last}Resource".constantize.new(self).serialize)
  end
end
