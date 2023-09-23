module Contactable
  extend ActiveSupport::Concern

  def contacts
    channels = Conversation.my_channels(userable_id: self.id, userable_type: self.class.name)
    self.class.joins("LEFT OUTER JOIN conversation_members ON conversation_members.user_id = users.id")
      .where("conversation_members.conversation_id": channels.select("conversations.id"))
      .where("conversation_members.user_id != ?", id)
      .group("users.id")
  end
end
