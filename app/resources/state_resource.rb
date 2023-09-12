# == Schema Information
#
# Table name: states
#
#  id         :uuid             not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class StateResource < BaseResource
  attributes :id, :name
end
