class PaymentSweeper < ActionController::Caching::Sweeper
  observe Payment

  def after_update(payment)
    expire_index
  end

  def after_create(payment)
    expire_index
  end

  def after_edit(payment)
    expire_index
  end

  def after_destroy(payment)
    expire_index
  end

  private

  def expire_index
    expire_action(controller: '/contracts', action: :index)
    expire_action(controller: '/payments', action: :index)
    expire_action(controller: '/strategic_planning', action: :index)
  end
end
