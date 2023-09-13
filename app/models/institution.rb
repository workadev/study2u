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
#  phone_number     :string
#  post_code        :string
#  reputation       :string
#  scholarship      :boolean          default(FALSE)
#  short_desc       :string
#  size             :string
#  status           :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  created_by_id    :uuid
#  state_id         :uuid
#
# Indexes
#
#  index_institutions_on_state_id  (state_id)
#
class Institution < ApplicationRecord
  include Searchable
  include ImageUploader.attachment(:logo)

  STATUS = ["active", "inactive"]
  INSTITUTION_TYPE = ["college", "university"]
  OWNERSHIP = ["public", "private"]
  SIZE = ["Small", "Medium", "Large", "Very Large"]

  add_scope_and_check_method(constants: STATUS, field_name: "status")
  add_scope_and_check_method(constants: INSTITUTION_TYPE, field_name: "institution_type")
  add_scope_and_check_method(constants: OWNERSHIP, field_name: "ownership", prefix: "scope")

  belongs_to :state, optional: true
  belongs_to :created_by, polymorphic: true, optional: true

  delegate :name, to: :state, prefix: true, allow_nil: true
  delegate :name, to: :created_by, prefix: true, allow_nil: true

  has_many :institution_interests, dependent: :destroy
  has_many :interests, through: :institution_interests

  has_many :staff_institutions, dependent: :destroy
  has_many :staffs, through: :staff_institutions

  has_many :institution_majors, dependent: :destroy
  has_many :majors, through: :institution_majors

  has_many :institution_study_levels, dependent: :destroy
  has_many :study_levels, through: :institution_study_levels

  has_many :user_institutions, dependent: :destroy
  has_many :users, through: :user_institutions

  has_many :images, -> { where(imageable_type: "Institution") }, foreign_key: "imageable_id", dependent: :destroy
  has_many :videos, -> { where(videoable_type: "Institution") }, foreign_key: "videoable_id", dependent: :destroy

  accepts_nested_attributes_for :institution_majors, allow_destroy: :true, reject_if: :all_blank
  accepts_nested_attributes_for :images, allow_destroy: :true, reject_if: :all_blank
  accepts_nested_attributes_for :videos, allow_destroy: :true, reject_if: :all_blank

  validates_presence_of :name, :short_desc, :address
  validates_inclusion_of :status, in: STATUS
  validates_inclusion_of :institution_type, in: INSTITUTION_TYPE
  validates_inclusion_of :ownership, in: OWNERSHIP
  validates_inclusion_of :size, in: SIZE, allow_nil: true

  before_validation :set_status

  scope :by_created_by_id,->(created_by_id, created_by_type) {
    where(created_by_id: created_by_id, created_by_type: created_by_type)
  }

  def set_status
    self.status = "active" if self.status.blank?
  end

  def self.get(params: {})
    institutions = Institution.active
    institutions = institutions.search(search_value: params[:search], search_by: ["institutions.name"]) if params[:search].present?
    institutions = institutions.send(params[:institution_type]) if INSTITUTION_TYPE.include?(params[:institution_type])
    institutions = institutions.send("scope_#{params[:ownership]}") if OWNERSHIP.include?(params[:ownership])
    return institutions
  end

  def self.recommendations(user_id:)
    user = User.find_by_id(user_id)
    interest_ids = user&.interest_ids

    if user.present? && interest_ids.present?
      major_ids = Major.joins(:interests).where("interests.id in (?)", interest_ids).group("majors.id").pluck("majors.id")
      Institution
        .joins("LEFT OUTER JOIN user_institutions ON user_institutions.user_id = '#{user_id}' AND user_institutions.institution_id = institutions.id")
        .joins(:majors, :interests)
        .where("user_institutions.id is null")
        .where("majors.id IN (?) OR interests.id IN (?)", major_ids, interest_ids)
    else
      Institution.none
    end
  end

  def self.shortlisted_users(opt={})
    shortlisted = []
    shortlisted = opt[:current_user].institutions
      .where("institution_id::text IN (?)", opt[:ids])
      .pluck(:institution_id) if opt[:current_user].present? && opt[:ids].present?

    return { institution_ids: shortlisted }
  end
end
