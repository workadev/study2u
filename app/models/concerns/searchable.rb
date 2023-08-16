module Searchable
  extend ActiveSupport::Concern

  module ClassMethods
    def search(search_value:, search_by: [], join_by: "OR", autocomplete: false)
      join_by = join_by.downcase.strip
      raise Exception, "Only allowed 'or' OR 'and' for join_by value" unless ["or", "and"].include?(join_by)
      if search_value.present? && search_by.class.eql?(Array)
        search_value = search_value.strip
        queries = ""
        search_by.each_with_index do |by, index|
          queries += " #{join_by} " if index > 0
          ilike = autocomplete ? "#{search_value}%" : "%#{search_value}%"
          search_value = ActiveRecord::Base.connection.quote(ilike)
          queries += "#{by} ilike #{search_value}"
        end
        begin
          where("#{queries}")
        rescue => e
          return e.message
        end
      else
        all
      end
    end
  end
end
