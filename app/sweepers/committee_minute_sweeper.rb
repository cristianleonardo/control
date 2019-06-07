class CommitteeMinuteSweeper < ActionController::Caching::Sweeper
  observe CommitteeMinute

  def after_update(committee_minute)
    expire_index
  end

  def after_create(committee_minute)
    expire_index
  end

  def after_destroy(committee_minute)
    expire_index
  end

  def after_edit(committee_minute)
    expire_index
  end

  private

  def expire_index
    expire_action(controller: '/certificates', action: :index)
  end
end
