class ContractorSweeper < ActionController::Caching::Sweeper
  observe Contractor

  def after_update(contractor)
    expire_index
  end

  def after_create(contractor)
    expire_index
  end

  def after_destroy(contractor)
    expire_index
  end

  def after_edit(contractor)
    expire_index
  end

  private

  def expire_index
    expire_action(controller: '/contracts', action: :index)
    expire_action(controller: '/payments', action: :index)
  end
end
