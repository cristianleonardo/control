class CertificateSweeper < ActionController::Caching::Sweeper
  observe Certificate

  def after_update(certificate)
    expire_index
  end

  def after_create(certificate)
    expire_index
  end

  def after_destroy(certificate)
    expire_index
  end

  def after_edit(certificate)
    expire_index
  end

  private

  def expire_index
    expire_action(controller: '/certificates', action: :index)
    expire_action(controller: '/contracts', action: :index)
  end
end
