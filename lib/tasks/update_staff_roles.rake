namespace :update do
  task :staffs_roles => :environment do
    role_id = Role.where("name = ?", "Staff Admin").first&.id
    Staff.where("role_id is null").update_all(role_id: role_id)
  end
end
