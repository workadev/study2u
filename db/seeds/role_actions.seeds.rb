require_relative 'support'
extend Support

after :roles, :actions do
  role_names = ["Super Admin"]

  role_names.each do |role_name|
    role = Role.find_by_name(role_name)

    Action.all.each do |action|
      row = RoleAction.find_or_initialize_by(role_id: role.id, action_id: action.id)
      row.save! if row.changed? && row.valid?
    end
  end
end

notify(__FILE__)
