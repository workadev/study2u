# == Schema Information
#
# Table name: subscriptions
#
#  id         :uuid             not null, primary key
#  email      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class SubscriptionResource < BaseResource
  attributes :id, :email
end
