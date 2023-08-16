class Admin::DetailTableComponent < ViewComponent::Base
  include ApplicationHelper

  def initialize(headers:, objects:, options:, pagy:)
    @headers = headers
    @objects = objects
    @options = options
    @pagy = pagy
  end
end
