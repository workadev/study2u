class AddLatestDeletedTimetokenToConversationMembers < ActiveRecord::Migration[7.0]
  def change
    add_column :conversation_members, :latest_deleted_timetoken, :string
  end
end
