# == Schema Information
#
# Table name: roles
#
#  id         :uuid             not null, primary key
#  is_staff   :boolean          default(FALSE)
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
  validate :role_staff_contains_super_admin_actions

  scope :staff_roles, -> { where("is_staff = ?", true) }

  def at_least_one_index
    errors.add(:action_ids, "minimal 1 list page is selected") unless self.actions.map{ |x| x.action_key.split("_").last }.include?("index")
  end

  def role_staff_contains_super_admin_actions
    errors.add(:base, "Invalid actions selected") if is_staff && actions.map(&:is_staff).include?(false)
  end
end
