# == Schema Information
#
# Table name: users
#
#  id                     :uuid             not null, primary key
#  about_me               :text
#  address                :string
#  avatar_data            :text
#  birthday               :date
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  current_school         :string
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  first_name             :string
#  headline               :string
#  last_name              :string
#  last_online_at         :datetime
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string
#  nationality            :string
#  online                 :boolean
#  phone_number           :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  sign_in_count          :integer          default(0), not null
#  unconfirmed_email      :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  current_education_id   :uuid
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_current_education_id  (current_education_id)
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  attr_accessor :avatar_id, :reset_password, :update_password, :registration, :tnc, :current_password

  include ImageUploader.attachment(:avatar)
  include Jwtable
  include Uploadable

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :confirmable, :trackable

  has_many :devices, -> { where(deviceable_type: "User") }, foreign_key: "deviceable_id"

  has_many :user_interests, dependent: :destroy
  has_many :interests, through: :user_interests

  has_many :user_institutions, dependent: :destroy
  has_many :institutions, through: :user_institutions

  belongs_to :current_education, foreign_key: "current_education_id", class_name: "StudyLevel", optional: true

  validates_presence_of :password_confirmation, if: -> { reset_password || registration || update_password }
  validates_confirmation_of :password, if: -> { reset_password || registration || update_password }
  validates_presence_of :current_password, if: -> { update_password }
  validates_presence_of :tnc, if: -> { registration }, message: "must agree"

  validate :check_current_password, if: -> { update_password }

  def check_current_password
    errors.add(:current_password, "is invalid") unless User.find(self.id).valid_password?(current_password)
    errors.add(:password, "cannot be same like current password") unless current_password != password
  end
end
