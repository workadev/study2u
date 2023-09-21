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
#  role_id                :uuid
#
# Indexes
#
#  index_staffs_on_confirmation_token    (confirmation_token) UNIQUE
#  index_staffs_on_email                 (email) UNIQUE
#  index_staffs_on_reset_password_token  (reset_password_token) UNIQUE
#  index_staffs_on_role_id               (role_id)
#
class StaffResource < BaseResource
  INSTITUTIONS = ["institutions", "staffs.institutions"]

  many :institutions, resource: InstitutionResource, if: proc {
    INSTITUTIONS.any?{|i| params[:include].try(:include?, i) }
  }

  attributes :id, :confirmed_at, :email, :description, :title, :phone_number, :first_name, :last_name

  attribute :email_verified do |resource|
    resource.confirmed_at.present?
  end

  attribute :avatar do |resource|
    retrieve_url(url: resource.avatar_url)
  end
end
