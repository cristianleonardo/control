class UserPolicy
  attr_reader :user, :resource

  def initialize(user, resource)
    @user = user
    @resource = resource
  end

  def index?
    bt_administration_g
  end

  def new?
    bt_administration_g
  end

  def edit?
    bt_administration_g
  end

  def create?
    bt_administration_g
  end

  def update?
    bt_administration_g
  end

  def enable?
    bt_administration_g
  end

  def disable?
    bt_administration_g
  end

  def send_invitation?
    bt_administration_g
  end

  private

  def bt_administration_g # Belongs to administration group
    @user.role_group == 'administration'
  end
end
