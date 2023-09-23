module Conversationable
  extend ActiveSupport::Concern

  included do
    after_create :update_conversation
    after_destroy :update_conversation
  end

  def update_conversation
    if id_previously_changed?
      conversation.update(last_message_id: self.id, last_message_updated_at: Time.now.utc, updated_at: Time.now.utc)
    else #delete
      if conversation.last_message_id == self.id
        last_message = conversation.messages.order("created_at DESC").first
        conversation.update(last_message_id: last_message&.id, last_message_updated_at: last_message&.created_at || conversation.created_at, updated_at: last_message&.created_at || conversation.updated_at)
      end
    end
  end
end
