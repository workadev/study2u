class Admin::DashboardsController < AdminController
  def index
    @data = {}
    if current_admin_panel.class_name == "admin"
      [Institution, Interest, Major, Staff, User].each do |object|
        @data["total_#{object.name.downcase}".to_sym] = object.all.count
      end
    else
      @data[:total_article] = current_admin_panel.articles.count
      @data[:total_institution] = current_admin_panel.institutions.count
      @data[:total_message] = Message.where("conversation_id IN (?)", current_admin_panel.conversation_members.pluck(:conversation_id)).count
    end
  end
end
