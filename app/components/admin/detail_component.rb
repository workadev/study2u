class Admin::DetailComponent < ViewComponent::Base
  def initialize(title:, detail_type:, options:)
    @title = title
    @detail_type = detail_type
    @options = options
  end
end
