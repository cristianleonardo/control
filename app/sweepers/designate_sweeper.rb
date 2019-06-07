class DesignateSweeper < ActionController::Caching::Sweeper
  observe Designate

  def after_update(designate)
    expire_index
  end

  def after_create(designate)
    expire_index
  end

  def after_destroy(designate)
    expire_index
  end

  def after_edit(designate)
    expire_index
  end

  private

  def expire_index
    expire_action(controller: '/certificates', action: :index)
  end
end
