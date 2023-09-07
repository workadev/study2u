require_relative 'support'
extend Support

role_names = ["Super Admin", "Staff Admin", "Staff Member"]

role_names.each do |name|
  role = Role.find_by_name(name)

  if role.blank?
    role = Role.new(name: name)
    role.save(validate: false)
  end
end

notify(__FILE__)
