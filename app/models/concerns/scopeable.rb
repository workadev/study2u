module Scopeable
  extend ActiveSupport::Concern

  included do
    scope :alphabetically,->(column_name: nil) {
      column = column_name.present? ? "#{column_name}" : "#{klass.table_name}.name"
      order("#{column} ASC")
    }
    scope :newest,->(table: nil, column_name: "created_at") {
      column = table.present? ? "#{table}.#{column_name}" : "#{klass.table_name}.#{column_name}"
      order("#{column} DESC")
    }
    scope :oldest,->(table: nil, column_name: "created_at") {
      column = table.present? ? "#{table}.#{column_name}" : "#{klass.table_name}.#{column_name}"
      order("#{column} ASC")
    }
    scope :this_month, -> { where(created_at: Time.zone.now.beginning_of_month..Time.zone.now.end_of_month) }
  end
end
