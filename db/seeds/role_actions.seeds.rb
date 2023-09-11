require_relative 'support'
extend Support

action_by_name = {
  "Super Admin": Action.all,
  "Staff Admin": Action.joins(:category).where("categories.name in (?)", STAFF_FEATURES),
  "Staff Member": Action.joins(:category).where("categories.name in (?) AND actions.name ilike ?", STAFF_FEATURES, "%index%")
}

after :roles, :actions do
  action_by_name = action_by_name.transform_keys(&:to_s)
  role_names = action_by_name.keys

  role_names.each do |role_name|
    role = Role.find_by_name(role_name)

    action_by_name[role_name].each do |action|
      row = RoleAction.find_or_initialize_by(role_id: role.id, action_id: action.id)
      row.save! if row.changed? && row.valid?
    end
  end
end

notify(__FILE__)
