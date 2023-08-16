class Admin::BreadcrumbComponent < ViewComponent::Base
  def initialize(title: nil, links: [])
    @title = title
    @links = links.blank? ? [] : links
  end

  def before_render
    @title = params[:controller].split("/").last.humanize.capitalize if @title.blank?

    default_links = [{
      url: url_for(action: params[:action], controller: params[:controller]),
      title: @title
    }]

    @links = @links + default_links
  end
end
