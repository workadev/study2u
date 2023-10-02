# == Schema Information
#
# Table name: staffs
#
#  id                       :uuid             not null, primary key
#  avatar_data              :text
#  birthday                 :date
#  confirmation_sent_at     :datetime
#  confirmation_token       :string
#  confirmed_at             :datetime
#  current_sign_in_at       :datetime
#  current_sign_in_ip       :string
#  description              :string
#  email                    :string           default(""), not null
#  encrypted_password       :string           default(""), not null
#  first_name               :string
#  last_name                :string
#  last_online_at           :datetime
#  last_sign_in_at          :datetime
#  last_sign_in_ip          :string
#  nationality              :string
#  online                   :boolean          default(FALSE)
#  phone_number             :string
#  remember_created_at      :datetime
#  reset_password_sent_at   :datetime
#  reset_password_token     :string
#  sign_in_count            :integer          default(0), not null
#  title                    :string
#  unconfirmed_email        :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  current_qualification_id :uuid
#  role_id                  :uuid
#
# Indexes
#
#  index_staffs_on_confirmation_token        (confirmation_token) UNIQUE
#  index_staffs_on_current_qualification_id  (current_qualification_id)
#  index_staffs_on_email                     (email) UNIQUE
#  index_staffs_on_reset_password_token      (reset_password_token) UNIQUE
#  index_staffs_on_role_id                   (role_id)
#
class Staff < ApplicationRecord
  attr_accessor :avatar_id, :reset_password, :create_by_admin, :update_password, :registration, :tnc, :current_password

  include ImageUploader.attachment(:avatar)
  include Jwtable
  include Uploadable
  include Contactable

  belongs_to :role
  belongs_to :current_qualification, foreign_key: "current_qualification_id", class_name: "StudyLevel", optional: true

  delegate :name, to: :role, prefix: true, allow_nil: true
  delegate :name, to: :current_qualification, prefix: true, allow_nil: true

  has_many :created_institutions, -> { where(created_by_type: "Staff") }, class_name: "Institution", foreign_key: "created_by_id"
  has_many :staff_institutions, dependent: :destroy
  has_many :institutions, through: :staff_institutions
  has_many :devices, -> { where(deviceable_type: "Staff") }, foreign_key: "deviceable_id"
  has_many :articles, -> { where(userable_type: "Staff") }, foreign_key: "userable_id"
  has_many :conversation_members, -> { where(userable_type: "Staff") }, foreign_key: "userable_id"

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :confirmable, :trackable

  validates_presence_of :password_confirmation, if: -> { reset_password || registration || update_password }
  validates_confirmation_of :password, if: -> { reset_password || registration || update_password }
  validates_presence_of :current_password, if: -> { update_password }
  validates_presence_of :tnc, if: -> { registration }, message: "must agree"

  def name
    "#{first_name} #{last_name}".try(:strip)
  end
end
