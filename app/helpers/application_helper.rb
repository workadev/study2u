module ApplicationHelper
  include Pagy::Frontend
  include WordHelper

  def application_policy(userable, controller, action)
    ApplicationPolicy.new(user: userable, controller: controller, action: action).have_access?
  end

  def action_policy(action)
    application_policy(current_admin_panel, params[:controller].split("/").last, action)
  end

  def show_field(title:, opt: {})
    field = title.downcase.parameterize(separator: '_')
    value = opt[:object].send(:try, field)

    if ["action"].include?(field)
      links = opt[:links].find { |o| o.first.to_s == field }.try(:last) if opt[:links].present?
      value = generate_links(field: field, links: opt[:links], object: opt[:object]) if links.present?
    else
      image = opt[:images].find { |o| o.first.to_s == field }.try(:last) if opt[:images].present?
      value = generate_images(image: image, value: value, object: opt[:object]) if image.present? && value.present?

      file = opt[:files].find { |o| o.first.to_s == field } if opt[:files].present?
      value = generate_files(file: file, value: value) if file.present? && value.present?

      relation = opt[:relations].find { |o| o.first.to_s == field }.try(:last) if opt[:relations].present?

      if relation.present?
        value = generate_relations(relation: relation, value: value) if value.present?
        value = nil if value.blank?
      end

      if opt[:normalize].present? && value.present?
        object = opt[:normalize].find { |o| o.first.to_s == field }.try(:last)
        value = normalize(value) if object != nil
      end

      value = convert_to_list(value) if value.class.eql?(Array)
      value = "No" if value.class.eql?(FalseClass)
      value = "Yes" if value.class.eql?(TrueClass)
      value = datetime_only(value) if [Time, ActiveSupport::TimeWithZone, DateTime].include?(value.class)
      value = date_only(value) if value.class.eql?(Date)

      if opt[:raw].present? && value.present?
        object = opt[:raw].find { |o| o.first.to_s == field }.try(:last)
        value = raw(value) if object != nil
      end
    end

    if opt[:table]
      "<td>#{value rescue '-'}</td>".html_safe
    else
      "<tr>
        <td>#{title}</td>
        <td>#{value rescue '-'}</td>
      </tr>".html_safe
    end
  end

  def generate_links(field:, links: {}, object: nil)
    links.each do |link|
      name = link[:name].present? ? link[:name] : raw('<i class="' + link[:icon] + '""></i>')

      url = root_path
      link[:route_params].each do |params|
        url = link[:path]
        url = url.gsub(":#{params}", object.send(params).to_s) if object.present?
      end

      tooltip = { "data-toggle": "tooltip", "data-placement": "top", "title": link[:title] } if link[:title].present?
      value = link_to name, url, { class: link[:class] }.merge(tooltip)
    end

    return value
  end

  def generate_images(image:, value:, object:)
    if image.present?
      url = value.class.eql?(String) ? value : image[:display].present? ? object.send("#{field}_url", image[:display]) : value.url

      if url.present?
        value = link_to url, "data-lightbox": SecureRandom.uuid, "data-alt": image[:alt] do
          image_tag url, alt: image[:alt], style: "max-width: 200px;"
        end
      end
    end

    return value
  end

  def generate_files(file:, value:)
    if file.present?
      url = value.class.eql?(String) ? value : value.url
      value = link_to value.metadata["filename"], url, download: value.metadata["filename"] if url.present?
    end

    return value
  end

  def generate_relations(relation:, value:)
    if relation.present?
      field = relation[:field].to_sym
      value = relation[:using_map].present? ? value.map(&field) : value.try(:pluck, relation[:field])
      is_image = relation[:image] || false
      value = relation[:return_list].present? ? convert_to_list(value: value, image: is_image) : value.try(:join, ", ")
    end

    return value
  end

  def convert_to_list(value:, image: false)
    new_value = ["<ul style='padding-left: 0;'>"]

    value.each do |value|
      if image
        url = ImageUploader::Attacher.from_data(Oj.load(value))&.url rescue nil
        if url.present?
          url = retrieve_url(url: url)
          value = generate_images(image: { alt: "Image" }, value: url, object: nil)
          style = "style='margin-bottom: 5px;'"
        end
      end

      new_value.push("<li #{style}>#{value}</li>")
    end

    new_value << "</ul>"
    new_value.join(" ")
  end

  def display_status(status:)
    badge = case status
    when "approved"
      "success"
    when "rejected"
      "danger"
    when "pending"
      "info"
    when "cancelled"
      "warning"
    end

    "<span class='badge badge-light-#{badge}'>#{status.try(:upcase)}</span>".html_safe
  end

  def true_or_false(condition:, flag_name: nil)
    badge = condition ? "success" : "primary"
    span_name = flag_name.present? ? flag_name : condition ? "YES" : "NO"
    "<span class='badge badge-light-#{badge}'>#{span_name}</span>".html_safe
  end

  def retrieve_url(url:)
    url.try(:split, "?").try(:first) if url.present?
  end

  def check_image(object:, field_name:)
    begin
      ("<span class='form-text'>" + File.basename(object.send(field_name).try(:url).try(:split, "?").try(:first)) + "</span>").html_safe if object.send(field_name).present?
    rescue StandardError => e
      nil
    end
  end
end
