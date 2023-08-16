require_relative 'support'
extend Support

after :roles do
  actions = ["index", "create", "update", "destroy", "show"]
  arrays = [
    [["dashboards"], ["index"]],
    [["admins", "roles"], actions],
    [["users"], ["index", "show"]]
  ]

  arrays.each do |array|
    Action.generate_actions(categories: array[0], actions: array[1])
  end
end

notify(__FILE__)
