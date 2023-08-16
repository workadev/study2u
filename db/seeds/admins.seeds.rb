require_relative 'support'
extend Support

after :role_actions do
  role = Role.find_by(name: "Super Admin")

  Admin.create(
    email: SUPER_ADMIN_EMAIL,
    name: "Super Admin",
    role_id: role.id,
    password: "secure_password"
  )
end

notify(__FILE__)
