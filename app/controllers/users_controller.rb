class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:activate]
  before_action :set_user, only: [:edit, :update, :enable, :disable, :send_invitation]

  def index
    @users = User.internal
    authorize @users
  end

  def new
    @user = User.new
    authorize @user
  end

  def edit
    authorize @user
  end

  def create
    @user = User.new(user_params)
    authorize @user

    respond_to do |format|
      if @user.save
        format.html { redirect_to users_path, notice: 'El usuario fue creada exitosamente.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    authorize @user
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to users_path, notice: 'El usuario fue actualizada exitosamente.' }
      else
        format.html { render :edit }
      end
    end
  end

  def enable
    authorize @user
    respond_to do |format|
      if @user.update_attributes(disabled: false)
        format.html { redirect_to edit_user_path(@user), notice: 'El usuario fue habilitado exitosamente.' }
      else
        format.html { render :edit }
      end
    end
  end

  def disable
    authorize @user
    respond_to do |format|
      if @user.update_attributes(disabled: true)
        format.html { redirect_to edit_user_path(@user), notice: 'El usuario fue deshabilitado exitosamente.' }
      else
        format.html { render :edit }
      end
    end
  end

  def send_invitation
    authorize @user
    @user.send_invitation
    redirect_to edit_user_path(params[:id]), notice: "La invitacion llegara en breve a su correo"
  end

  def impersonate
    user = User.find(params[:id])
    impersonate_user(user)
    redirect_to(request.referer || root_path)
  end

  def stop_impersonating
    stop_impersonating_user
    redirect_to(request.referer || root_path)
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(
      :identification,
      :identification_type,
      :firstname,
      :lastname,
      :email,
      :role_group,
      :password,
      :password_confirmation
    )
  end
end
