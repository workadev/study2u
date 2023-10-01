module Cable::Message
  extend ActiveSupport::Concern

  included do
    after_create { broadcast_data(action: "create") }
    after_update { broadcast_data(action: "update") }
    after_destroy { broadcast_data(action: "destroy") }
  end

  def broadcast_data(action:)
    if conversation.present? && (["create", "destroy"].include?(action) || (action.eql?("update") && previous_changes.present?))
      conversation.conversation_members.where(status: "inactive").update_all(status: "active") if action == "create"

      action = action.eql?("update") ? "create" : action
      conversation.users.each do |user|
        GlobalMessageChannel.broadcast_to(user, payload(action: action))
      end
    end
  end

  def payload(action:)
    {
      event: event,
      action: action,
      data: Oj.load(cable_payload)
    }
  end
end
