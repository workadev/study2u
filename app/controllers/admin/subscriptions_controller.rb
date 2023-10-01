class Admin::SubscriptionsController < AdminController
  before_action :set_index, only: :index

  private

  def set_index
    @query = Subscription.all
  end
end
