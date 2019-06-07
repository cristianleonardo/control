class SourceSweeper < ActionController::Caching::Sweeper
  observe Source

  def after_update(source)
    expire_index
  end

  def after_create(source)
    expire_index
  end

  def after_destroy(source)
    expire_index
  end

  def after_edit(source)
    expire_index
  end

  private

  def expire_index
    expire_action(controller: '/contracts', action: :index)
    expire_action(controller: '/certificates', action: :index)
    expire_action(controller: '/strategic_planning', action: :index)
  end
end
