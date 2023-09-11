# == Schema Information
#
# Table name: states
#
#  id         :uuid             not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class State < ApplicationRecord
  has_many :institutions

  validates_presence_of :name
  validates_uniqueness_of :name, case_sensitive: false
end
