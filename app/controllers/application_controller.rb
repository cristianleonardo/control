class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include Pundit
  impersonates :user, unless: Rails.env.production?

  before_action :set_paper_trail_whodunnit
  before_action :reject_disabled_user
  before_action :set_session_variables, only: :index

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def set_session_variables
    session[:contracts_hash] = {} unless session[:contracts_hash]
    session[:certificates_hash] = {} unless session[:certificates_hash]
    session[:payments_hash] = {} unless session[:payments_hash]
  end

  def user_not_authorized
    flash[:alert] = 'No está autorizado para realizar esta acción.'
    redirect_to(request.referer || root_path)
  end

  def reject_disabled_user
    if current_user && current_user.disabled
      sign_out current_user
      redirect_to new_user_session_path, alert: ' El usuario se encuentra inhabilitado, contacte al administrador.'
    end
  end
end
