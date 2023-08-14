ApiPagination.configure do |config|
  # If you have more than one gem included, you can choose a paginator.
  config.paginator = :pagy # or :will_paginate

  # By default, this is set to 'Total'
  # config.total_header = 'X-Total'

  # By default, this is set to 'Per-Page'
  # config.per_page_header = 'X-Per-Page'

  # Optional: set this to add a header with the current page number.
  config.page_header = 'Page'

  # Optional: set this to add other response format. Useful with tools that define :jsonapi format
  # config.response_formats = [:json, :xml, :jsonapi]

  # Optional: what parameter should be used to set the page option
  config.page_param = :page
  # or
  # config.page_param do |params|
  #   params[:page][:number] if params[:page].is_a?(ActionController::Parameters)
  # end

  # Optional: what parameter should be used to set the per page option
  config.per_page_param = :per_page
  # or
  # config.per_page_param do |params|
  #   params[:page][:size] if params[:page].is_a?(ActionController::Parameters)
  # end

  # Optional: Include the total and last_page link header
  # By default, this is set to true
  # Note: When using kaminari, this prevents the count call to the database
  # config.include_total = true
end

require "rails/pagination"
Rails::Pagination.module_eval do
  private

  def _paginate_collection(collection, options={})
    options[:page] = ApiPagination.config.page_param(params)
    options[:per_page] ||= ApiPagination.config.per_page_param(params)

    collection, pagy = ApiPagination.paginate(collection, options)

    links = (headers['Link'] || '').split(',').map(&:strip)
    url   = base_url + request.path_info
    pages = ApiPagination.pages_from(pagy || collection, options)

    pages.each do |k, v|
      new_params = request.query_parameters.merge(:page => v)
      links << %(<#{url}?#{new_params.to_param}>; rel="#{k}")
    end

    total_header    = ApiPagination.config.total_header
    per_page_header = ApiPagination.config.per_page_header
    page_header     = ApiPagination.config.page_header
    include_total   = ApiPagination.config.include_total

    headers['Link'] = links.join(', ') unless links.empty?
    headers[per_page_header] = options[:per_page].to_s
    headers[page_header] = options[:page].to_s unless page_header.nil?
    headers[total_header] = total_count(pagy || collection, options).to_s if include_total
    headers["Next"] = pagy.next unless pagy.next.nil?
    headers["Prev"] = pagy.prev unless pagy.prev.nil?
    headers["Last"] = pagy.last unless pagy.last.nil?

    return collection
  end
end
