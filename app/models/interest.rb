# == Schema Information
#
# Table name: interests
#
#  id         :uuid             not null, primary key
#  icon_color :string
#  icon_data  :text
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Interest < ApplicationRecord
  include ImageUploader.attachment(:icon)

  has_many :institution_interests, dependent: :destroy
  has_many :institutions, through: :institution_interests

  validates_presence_of :name
end
