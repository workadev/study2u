class ApplicationPolicy
  attr_reader :user, :record
  CREATE = ["new"]
  UPDATE = ["edit"]

  def initialize(user:, controller:, action:)
    action = CREATE.include?(action) ? "create" : (UPDATE.include?(action) || action.include?("update")) ? "update" : action
    @action_keys = user.role.actions.map{|x| x['action_key']}
    @condition = "#{ENV['APP_NAME']}_#{controller}_#{action}"
  end

  def index?
    false
  end

  def show?
    false
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  def have_access?
    @action_keys.include?(@condition)
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope.all
    end
  end
end
