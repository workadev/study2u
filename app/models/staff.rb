# == Schema Information
#
# Table name: staffs
#
#  id                     :uuid             not null, primary key
#  avatar_data            :text
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string
#  description            :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  first_name             :string
#  last_name              :string
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string
#  phone_number           :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  sign_in_count          :integer          default(0), not null
#  title                  :string
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
  attr_accessor :avatar_id, :reset_password, :create_by_admin

  include ImageUploader.attachment(:avatar)
  include Jwtable
  include Uploadable

  has_many :staff_institutions, dependent: :destroy
  has_many :institutions, through: :staff_institutions

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :confirmable, :trackable

  has_many :devices, -> { where(deviceable_type: "Staff") }, foreign_key: "deviceable_id"

  validates_presence_of :password_confirmation, if: -> { reset_password }
  validates_confirmation_of :password, if: -> { reset_password }
  validates_presence_of :first_name

  private

  def send_confirmation_notification?
    create_by_admin ? false : true
  end

  def send_email_changed_notification?
    create_by_admin ? false : true
  end

  def send_password_change_notification?
    create_by_admin ? false : true
  end

  def reconfirmation_required?
    create_by_admin ? false : true
  end
end
