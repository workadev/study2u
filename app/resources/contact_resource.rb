# == Schema Information
#
# Table name: contacts
#
#  id         :uuid             not null, primary key
#  email      :string
#  message    :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class ContactResource < BaseResource
  attributes :id, :email, :message, :name
end
