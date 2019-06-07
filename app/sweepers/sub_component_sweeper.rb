class SubComponentSweeper < ActionController::Caching::Sweeper
  observe SubComponent

  def after_update(sub_component)
    expire_index
  end

  def after_create(sub_component)
    expire_index
  end

  def after_destroy(sub_component)
    expire_index
  end

  def after_edit(sub_component)
    expire_index
  end

  private

  def expire_index
    expire_action(controller: '/strategic_planning', action: :index)
    expire_action(controller: '/certificates', action: :index)
  end
end
