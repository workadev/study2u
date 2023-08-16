# == Schema Information
#
# Table name: staffs
#
#  id                     :uuid             not null, primary key
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string
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
#  index_staffs_on_confirmation_token    (confirmation_token) UNIQUE
#  index_staffs_on_email                 (email) UNIQUE
#  index_staffs_on_reset_password_token  (reset_password_token) UNIQUE
#
class Staff < ApplicationRecord
  attr_accessor :avatar_id, :reset_password

  include Jwtable

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :confirmable, :trackable

  has_many :devices, -> { where(deviceable_type: "Staff") }, foreign_key: "deviceable_id"

  validates_presence_of :password_confirmation, if: -> { reset_password }
  validates_confirmation_of :password, if: -> { reset_password }
end
