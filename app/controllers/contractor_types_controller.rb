class ContractorTypesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_contractor_type, only: [:edit, :update, :destroy]

  def index
    @contractor_types = ContractorType.all
    authorize @contractor_types
  end

  def new
    @contractor_type = ContractorType.new
    authorize @contractor_type
  end

  def edit
    authorize @contractor_type
  end

  def create
    @contractor_type = ContractorType.new(contractor_type_params)
    authorize @contractor_type

    respond_to do |format|
      if @contractor_type.save
        format.html { redirect_to contractor_types_path, notice: 'El tipo de contratista fue creado correctamente' }
      else
        format.html { render :new}
      end
    end
  end

  def update
    authorize @contractor_type

    respond_to do |format|
      if @contractor_type.update(contractor_type_params)
        format.html { redirect_to contractor_types_path, notice: 'El tipo de contratista fue actualizado exitosamente'}
      else
        format.html { render :edit}
      end
    end
  end

  def destroy
    authorize @contractor_type
    @contractor_type.destroy
    respond_to do |format|
      format.html { redirect_to contractor_types_url, notice: 'El tipo de contratista fue eliminado exitosamente'}
    end
  end

  private

  def set_contractor_type
    @contractor_type = ContractorType.find(params[:id])
  end

  def contractor_type_params
    params.require( :contractor_type).permit(:abbreviation, :name)
  end
end
