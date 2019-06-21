class ProvidersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_provider, only: [:edit, :update, :destroy]
  def index
    @providers = Provider.all
  end

  def new
    @provider = Provider.new
  end

  def edit
  end

  def create
    @provider = Provider.new(provider_params)
    respond_to do |format|
      if @provider.save
        format.html { redirect_to providers_path, notice: 'El registro se realizo correctamente.' }
      else
       format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @provider.update(provider_params)
        format.html { redirect_to providers_path, notice: 'El registro se realizo correctamente.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @provider.destroy
    respond_to do |format|
      format.html { redirect_to providers_path, notice: 'La adición fue eliminada exitosamente.' }
    end
  end

  private

  def set_provider
    @provider = Provider.find(params[:id])
  end

  def provider_params
    params.require(:provider).permit(
      :name,
      :number,
      :indentifier
    )
  end
end
