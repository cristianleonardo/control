class ContractSweeper < ActionController::Caching::Sweeper
  observe Contract

  def after_update(contract)
    expire_index
  end

  def after_create(contract)
    expire_index
  end

  def after_destroy(contract)
    expire_index
  end

  def after_edit(contract)
    expire_index
  end

  private

  def expire_index
    expire_action(controller: '/contracts', action: :index)
    expire_action(controller: '/payments', action: :index)
  end
end
