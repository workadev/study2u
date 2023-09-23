class Api::Staffs::V1::MessagesController < Api::StaffsController
  include Api::Conversation

  before_action :find_object
  before_action :check_conversation
  before_action :check_member
  before_action :set_index_messages
end
