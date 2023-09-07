# == Schema Information
#
# Table name: roles
#
#  id         :uuid             not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Role < ApplicationRecord
  has_many :admins
  has_many :staffs

  has_many :role_actions, dependent: :destroy
  has_many :actions, through: :role_actions

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :action_ids, presence: true
  validate :at_least_one_index

  def at_least_one_index
    errors.add(:action_ids, "minimal 1 list page is selected") unless self.actions.map{ |x| x.action_key.split("_").last }.include?("index")
  end
end
