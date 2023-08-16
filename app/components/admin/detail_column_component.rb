class Admin::DetailColumnComponent < ViewComponent::Base
  include ApplicationHelper

  def initialize(headers:, options:)
    @headers = headers
    @options = options
  end
end
