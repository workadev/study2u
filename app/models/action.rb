# == Schema Information
#
# Table name: actions
#
#  id          :uuid             not null, primary key
#  action_key  :string
#  description :string
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  category_id :uuid
#
# Indexes
#
#  index_actions_on_action_key   (action_key) UNIQUE
#  index_actions_on_category_id  (category_id)
#
class Action < ApplicationRecord
  belongs_to :category

  has_many :role_actions, dependent: :destroy
  has_many :roles, through: :role_actions

  scope :by_category, -> { includes(:category).joins(:category).order("categories.name").group_by {|item| item.category_name } }

  validates_presence_of :name, :action_key
  validates_uniqueness_of :action_key, case_sensitive: false

  delegate :name, to: :category, prefix: true, allow_nil: true

  ACTION_MAPPING = { "index": "list", "destroy": "delete", "show": "view" }
  NOT_PLURAL = ["Dashboard"]

  def self.generate_actions(categories: [], actions: [])
    records = []

    categories.each do |category|
      name = category.class.eql?(Hash) ? category[:name] : category
      name = name.humanize.split(" ").map(&:capitalize).join(" ")
      category = Category.find_by_name(name) || Category.new
      category.name = name

      actions.each do |action|
        description = action.try(:description)
        name = action.try(:name) || action
        name = ACTION_MAPPING[name] || name
        category_key = NOT_PLURAL.include?(category.name) ? category.name : category.name.pluralize
        action_key = "#{ENV['APP_NAME']}_#{to_key(category_key)}_#{to_key(name)}"
        action = Action.find_by_action_key(action_key) || Action.new
        action.name = "#{name.humanize.split(" ").map(&:capitalize).join(" ")} #{category.name}"
        action.category = category
        action.action_key = action_key
        action.description = description
        records.push(action)
      end
    end

    ActiveRecord::Base.transaction do
      records.each_with_index do |record, index|
        begin
          record.save!
        rescue StandardError => e
          return_value = e.message
          raise ActiveRecord::Rollback, return_value
        end
        break if return_value.present?
      end
    end
  end

  def self.to_key(name)
    name.split(" ").join("_").downcase
  end
end
