class PurchaseOrderPolicy
  attr_reader :user, :resource

  def initialize(user, resource)
    @user = user
    @resource = resource
  end

  def index?
    bt_administration_g ||
      bt_supervision_g ||
      bt_financial_g ||
      bt_financial_assistant_g ||
      bt_recruitment_g ||
      bt_reports_g
  end

  def new?
    bt_administration_g ||
      bt_financial_g ||
      bt_financial_assistant_g ||
      bt_recruitment_g ||
      bt_supervision_g
  end

  def show?
    bt_reports_g
  end

  def edit?
    bt_administration_g ||
      bt_financial_g ||
      bt_financial_assistant_g ||
      bt_recruitment_g ||
      bt_supervision_g
  end

  def create?
    bt_administration_g ||
      bt_financial_g ||
      bt_financial_assistant_g ||
      bt_recruitment_g ||
      bt_supervision_g
  end

  def update?
    bt_administration_g ||
      bt_financial_g ||
      bt_financial_assistant_g ||
      bt_recruitment_g ||
      bt_supervision_g
  end

  def destroy?
    bt_administration_g ||
      bt_supervision_g
  end

  private

  def bt_administration_g # Belongs to administration group
    @user.role_group == 'administration'
  end

  def bt_supervision_g # Belongs to supervision group
    @user.role_group == 'supervision'
  end

  def bt_financial_g # Belongs to financial group
    @user.role_group == 'financial'
  end

  def bt_recruitment_g # Belongs to recruitment group
    @user.role_group == 'recruitment'
  end

  def bt_reports_g # Belongs to reports group
    @user.role_group == 'reports'
  end

  def bt_financial_assistant_g # Belongs to financial assistant group
    @user.role_group == 'financial_assistant'
  end
end
