class Admin::ContactsController < AdminController
  before_action :set_index, only: :index

  private

  def set_index
    @query = Contact.all
  end
end
