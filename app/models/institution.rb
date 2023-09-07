# == Schema Information
#
# Table name: institutions
#
#  id               :uuid             not null, primary key
#  address          :string
#  area             :string
#  city             :string
#  country          :string
#  created_by_type  :string
#  description      :string
#  institution_type :string
#  latitude         :string
#  logo_data        :text
#  longitude        :string
#  name             :string
#  ownership        :string
#  post_code        :string
#  reputation       :string
#  short_desc       :string
#  size             :string
#  state            :string
#  status           :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  created_by_id    :uuid
#
class Institution < ApplicationRecord
  include ImageUploader.attachment(:logo)

  STATUS = ["active", "inactive"]
  INSTITUTION_TYPE = ["college", "university"]

  add_scope_and_check_method(constants: STATUS, field_name: "status")
  add_scope_and_check_method(constants: INSTITUTION_TYPE, field_name: "institution_type")

  belongs_to :created_by, polymorphic: true, optional: true

  has_many :institution_interests, dependent: :destroy
  has_many :interests, through: :institution_interests

  has_many :staff_institutions, dependent: :destroy
  has_many :institutions, through: :staff_institutions

  validates_presence_of :name, :short_desc, :address
  validates_inclusion_of :status, in: STATUS
  validates_inclusion_of :institution_type, in: INSTITUTION_TYPE

  before_validation :set_status

  def set_status
    self.status = "active" if self.status.blank?
  end
end
