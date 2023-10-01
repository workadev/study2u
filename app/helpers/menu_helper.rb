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
    "Institutions": {
      icon: "bx bxs-institution"
    },
    "Staffs": {
      icon: "bx bxs-user-badge"
    },
    "Articles": {
      icon: "bx bx-list-plus"
    },
    "Branches": {
      icon: "bx bx-buildings"
    },
    "States": {
      icon: "bx bxs-business"
    },
    "Study Levels": {
      icon: "bx bx-notepad"
    },
    "Majors": {
      icon: "bx bx-edit"
    },
    "Contacts": {
      icon: "bx bxs-contact",
      custom_name: "Contact Us"
    },
    "Subscriptions": {
      icon: "bx bx-bookmark-plus"
    }
  }
  MENU = ADMIN_FEATURES.map{ |feat| {
      name: feat,
      custom_name: OPTIONS[feat.to_sym].try(:[], :custom_name),
      url: OPTIONS[feat.to_sym].try(:[], :url),
      icon: OPTIONS[feat.to_sym].try(:[], :icon)
    }
  }

  def sidebar_link(scope_name:, name:, options: {})
    url = options[:url] || send("#{scope_name}_#{normalize_helper(word: name)}_path")
    content_tag(:li, class: "#{active(url, tag: "li")}") do
      link_to url, class: "waves-effect #{active(url)}" do
        label = options[:custom_name].present? ? options[:custom_name] : name
        content_tag(:i, "", class: options[:icon]) + content_tag(:span, label)
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
