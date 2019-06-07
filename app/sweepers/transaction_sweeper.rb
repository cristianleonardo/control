class TransactionSweeper < ActionController::Caching::Sweeper
  observe Transaction

  def after_create(transaction)
    expire_index
  end

  def after_destroy(transaction)
    expire_index
  end

  private

  def expire_index
    expire_action(controller: '/certificates', action: :index) if boolean("Designate")
    expire_action(controller: '/contracts', action: :index) if boolean("Fund")
    expire_action(controller: '/strategic_planning', action: :index)
  end

  def boolean(type)
    params[:polymorphic_type] == type || params[:action] == "destroy"
  end
end
