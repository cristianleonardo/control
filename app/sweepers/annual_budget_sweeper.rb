class AnnualBudgetSweeper < ActionController::Caching::Sweeper
  observe AnnualBudget

  def after_update(annual_budgets)
    expire_index
  end

  def after_create(annual_budgets)
    expire_index
  end

  def after_destroy(annual_budgets)
    expire_index
  end

  def after_edit(annual_budgets)
    expire_index
  end

  private

  def expire_index
    expire_action(controller: '/certificates', action: :index)
  end
end
