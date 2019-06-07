class ContractorTypePolicy
  attr_reader :user, :resource

  def initialize(user, resource)
    @user = user
    @resource = resource
  end

  def index?
    bt_administration_g || bt_supervision_g
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

  def destroy?
    bt_administration_g
  end

  private

  def bt_administration_g # Belongs to administration group
    @user.role_group == 'administration'
  end

  def bt_supervision_g # Belongs to supervision group
    @user.role_group == 'supervision'
  end
end
