class BudgetSweeper < ActionController::Caching::Sweeper
  observe Budget

  def after_update(budget)
    expire_index
  end

  def after_edit(budget)
    expire_index
  end

  def after_destroy(budget)
    expire_index
  end

  def after_create(budget)
    expire_index
  end

  private

  def expire_index
    expire_action(controller: '/contracts', action: :index)
  end
end
