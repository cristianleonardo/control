class SubComponentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_component
  before_action :set_sub_component, only: [:show, :edit, :update, :destroy]

  def index
    @sub_components = @component.sub_components
    authorize @sub_components
  end

  def new
    @sub_component = @component.sub_components.new
    authorize @sub_component
  end

  def edit
    authorize @sub_component
  end

  def create
    @sub_component = @component.sub_components.new(sub_component_params)
    authorize @sub_component

    respond_to do |format|
      if @sub_component.save
        format.html { redirect_to component_sub_components_path(@component), notice: 'El sub componente fue creado exitosamente' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    authorize @sub_component

    respond_to do |format|
      if @sub_component.update(sub_component_params)
        format.html { redirect_to component_sub_components_path(@component), notice: 'El sub componente fue actualizado exitosamente' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    authorize @sub_component
    @sub_component.destroy
    respond_to do |format|
      format.html { redirect_to component_sub_components_path(@component) }
    end
  end

  private

  def set_component
    @component = Component.find(params[:component_id])
  end

  def set_sub_component
    @sub_component = SubComponent.find(params[:id])
  end

  def sub_component_params
    params.require(:sub_component).permit(:component_id, :name, :code)
  end
end
