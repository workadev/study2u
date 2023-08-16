require_relative 'support'
extend Support

roles = [
  { name: "Super Admin" }
]

roles.each do |attribute|
  role = Role.find_by(attribute)

  if role.blank?
    role = Role.new(attribute)
    role.save(validate: false)
  end
end

notify(__FILE__)
