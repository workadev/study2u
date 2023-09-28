module Api::Presence
  include Api::User

  extend ActiveSupport::Concern

  included do
    before_action :set_index, only: :index
  end

  def set_index
    class_name = user.class.name == "Staff" ? "User" : "Staff"
    @query = user.contacts.where("#{class_name.constantize.table_name}.online = true")
  end
end
