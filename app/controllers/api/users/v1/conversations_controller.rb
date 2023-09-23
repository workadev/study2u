class Api::Users::V1::ConversationsController < Api::UsersController
  include Api::Conversation

  before_action :set_index_conversations, only: :index
  before_action :check_conversation, only: :show
  before_action :check_member, only: :show
end
