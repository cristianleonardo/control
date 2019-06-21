module Users
  class InvitationsController < ApplicationController
    def edit
      @user = User.find_by(invitation_token: params[:id])
      sign_out :user
    end

    def update
      @user = User.find_by(invitation_token: params[:id])
      respond_to do |format|
        if @user.update(user_params)
          @user.update_attributes(active: true)
          sign_in @user
          format.html { redirect_to dashboard_path, notice: 'El usuario fue activado exitosamente, Bienvenido!.' }
        else
          format.html { render :edit }
        end
      end
    end

    private

    def user_params
      params.require(:user).permit(
        :password,
        :password_confirmation
      )
    end
  end
end
