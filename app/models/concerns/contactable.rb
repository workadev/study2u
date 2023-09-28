module Contactable
  extend ActiveSupport::Concern

  def contacts
    channels = Conversation.my_channels(userable_id: self.id, userable_type: self.class.name)
    class_name = self.class.name == "Staff" ? "User" : "Staff"
    class_name.constantize.joins("LEFT OUTER JOIN conversation_members ON conversation_members.userable_id = #{class_name.constantize.table_name}.id AND conversation_members.userable_type = '#{class_name}'")
      .where("conversation_members.conversation_id": channels.select("conversations.id"))
      .where("conversation_members.userable_id != ?", id)
      .group("#{class_name.constantize.table_name}.id")
  end
end
