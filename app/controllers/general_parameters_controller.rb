class GeneralParametersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_general_parameter, only: [:edit, :update, :destroy]

  def index
    @general_parameters = GeneralParameter.all
  end

  def new
    @general_parameter = GeneralParameter.new
  end

  def edit; end

  def create
    @general_parameter = GeneralParameter.new(general_parameter_params)
    respond_to do |format|
      if @general_parameter.save
        format.html { redirect_to general_parameters_path, notice: 'El parametro fue creado correctamente' }
      else
        format.html { render :new}
      end
    end
  end

  def update
    respond_to do |format|
      if @general_parameter.update(general_parameter_params)
        format.html { redirect_to general_parameters_path, notice: 'El parametro fue actualizado exitosamente'}
      else
        format.html { render :edit}
      end
    end
  end

  def destroy
    @general_parameter.destroy
    respond_to do |format|
      format.html { redirect_to general_parameters_url, notice: 'El parametro fue eliminado exitosamente'}
    end
  end

  private

  def set_general_parameter
    @general_parameter = GeneralParameter.find(params[:id])
  end

  def general_parameter_params
    params.require( :general_parameter).permit(:value, :name)
  end
end
