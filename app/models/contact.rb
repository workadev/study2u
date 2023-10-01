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
class Contact < ApplicationRecord
  validates_uniqueness_of :email, scope: [:message, :name]
  validates_presence_of :email, :message, :name
  validates_format_of :email, with: Devise::email_regexp

  after_create :send_email

  def send_email
    ContactUsMailer.with(contact: self).send_message.deliver_now
  end
end
