module MenuHelper
  include ApplicationHelper

  # Route helper example
  # admin_dashboards_path
  # you can add custom url, action if name is different with route helper
  OPTIONS = {
    "Dashboard": {
      icon: "bx bx-home-circle"
    },
    "Admins": {
      icon: "bx bx-shield-quarter"
    },
    "Roles": {
      icon: "bx bx-key"
    },
    "Users": {
      icon: "bx bxs-user"
    },
    "Interests": {
      icon: "bx bxs-purchase-tag"
    },
    "institutions": {
      icon: "bx bxs-institution"
    }
  }
  MENU = ADMIN_FEATURES.map{ |feat| { name: feat, url: OPTIONS[feat.to_sym].try(:[], :url), icon: OPTIONS[feat.to_sym].try(:[], :icon) } }

  def sidebar_link(name:, options: {})
    url = options[:url] || send("admin_#{normalize_helper(word: name)}_path")
    content_tag(:li, class: "#{active(url, tag: "li")}") do
      link_to url, class: "waves-effect #{active(url)}" do
        content_tag(:i, "", class: options[:icon]) + content_tag(:span, name)
      end
    end
  end

  def normalize_helper(word:)
    word.gsub(" ", "_").downcase.pluralize
  end

  def active(url, tag: nil)
    class_name = tag == "li" ? "mm-active" : "active"
    return request.path == url ? class_name : ""
  end
end
