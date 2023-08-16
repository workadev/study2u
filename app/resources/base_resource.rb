class BaseResource
  include Alba::Resource
  include Api::ResourceHelper

  root_key!

  attribute :created_at, if: proc { |resource|
    resource.try(:created_at).present?
  } do |resource|
    resource.to_string(resource.created_at)
  end

  attribute :updated_at, if: proc { |resource|
    resource.try(:updated_at).present?
  } do |resource|
    resource.to_string(resource.updated_at)
  end
end
