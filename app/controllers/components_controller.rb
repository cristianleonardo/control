class ComponentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_component, only: [:edit, :update, :destroy]

  def index
    @components = Component.all
    authorize @components
  end

  def new
    @component = Component.new
    authorize @component
  end

  def edit
    authorize @component
  end

  def create
    @component = Component.new(component_params)
    authorize @component

    respond_to do |format|
      if @component.save
        format.html { redirect_to components_path, notice: 'El componente fue creado correctamente' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    authorize @component

    respond_to do |format|
      if @component.update(component_params)
        format.html { redirect_to components_path, notice: 'El componente fue actualizado exitosamente' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    authorize @component
    @component.destroy
    respond_to do |format|
      format.html { redirect_to components_url, notice: 'El componente fue eliminado exitosamente' }
    end
  end

  private

  def set_component
    @component = Component.find(params[:id])
  end

  def component_params
    params.require(:component).permit(:code, :name, :description)
  end
end
