# == Schema Information
#
# Table name: role_actions
#
#  id         :uuid             not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  action_id  :uuid
#  role_id    :uuid
#
# Indexes
#
#  index_role_actions_on_action_id  (action_id)
#  index_role_actions_on_role_id    (role_id)
#
class RoleAction < ApplicationRecord
  belongs_to :role
  belongs_to :action

  validates_uniqueness_of :action_id, scope: [:role_id], message: "already choosed"
end
