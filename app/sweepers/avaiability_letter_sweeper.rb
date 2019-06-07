class AvaiabilityLetterSweeper < ActionController::Caching::Sweeper
  observe AvaiabilityLetter

  def after_update(avaiability_letter)
    expire_index
  end

  def after_create(avaiability_letter)
    expire_index
  end

  def after_destroy(avaiability_letter)
    expire_index
  end

  def after_edit(avaiability_letter)
    expire_index
  end

  private

  def expire_index
    expire_action(controller: '/certificates', action: :index)
  end
end
