class ComponentSweeper < ActionController::Caching::Sweeper
  observe Component

  def after_update(component)
    expire_index
  end

  def after_create(component)
    expire_index
  end

  def after_destroy(component)
    expire_index
  end

  def after_edit(component)
    expire_index
  end

  private

  def expire_index
    expire_action(controller: '/strategic_planning', action: :index)
    expire_action(controller: '/certificates', action: :index)
  end
end
