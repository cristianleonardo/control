class AdditionSweeper < ActionController::Caching::Sweeper
  observe Addition

  def after_update(addition)
    expire_index
  end

  def after_create(addition)
    expire_index
  end

  def after_edit(addition)
    expire_index
  end

  def after_destroy(addition)
    expire_index
  end

  private

  def expire_index
    expire_action(controller: '/contracts', action: :index)
  end
end
