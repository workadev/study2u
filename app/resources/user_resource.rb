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
class UserResource < BaseResource
  INSTITUTIONS = ["institutions", "users.institutions"]
  INTERESTS = ["interests", "users.interests"]

  one :current_education, resource: StudyLevelResource

  many :interests, resource: InterestResource, if: proc {
    INTERESTS.any?{|i| params[:include].try(:include?, i) }
  }

  many :institutions, resource: InstitutionResource, if: proc {
    INSTITUTIONS.any?{|i| params[:include].try(:include?, i) }
  }

  attributes :id, :confirmed_at, :email, :phone_number, :first_name, :last_name, :headline, :about_me, :address, :birthday, :nationality, :current_school

  attribute :email_verified do |resource|
    resource.confirmed_at.present?
  end

  attribute :avatar do |resource|
    retrieve_url(url: resource.avatar_url)
  end
end
