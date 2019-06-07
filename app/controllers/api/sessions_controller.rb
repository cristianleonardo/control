module API
  class SessionsController < ApplicationController
    def email_is_registrated
      user = User.find_by(email: Base64.urlsafe_decode64(params[:email]))
      render json: (user.present? ? true : false).to_json
    end
  end
end
