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
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  first_name             :string
#  headline               :string
#  last_name              :string
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string
#  phone_number           :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  sign_in_count          :integer          default(0), not null
#  unconfirmed_email      :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  attr_accessor :avatar_id, :reset_password

  include ImageUploader.attachment(:avatar)
  include Jwtable
  include Uploadable

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :confirmable, :trackable

  has_many :devices, -> { where(deviceable_type: "User") }, foreign_key: "deviceable_id"

  validates_presence_of :password_confirmation, if: -> { reset_password }
  validates_confirmation_of :password, if: -> { reset_password }
  validates_presence_of :first_name
end
