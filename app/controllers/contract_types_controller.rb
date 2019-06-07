class ContractTypesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_contract_type, only: [:edit, :update, :destroy]

  def index
    @contract_types = ContractType.all
    authorize @contract_types
  end

  def new
    @contract_type = ContractType.new
    authorize @contract_type
  end

  def edit
    authorize @contract_type
  end

  def create
    @contract_type = ContractType.new(contract_type_params)
    authorize @contract_type

    respond_to do |format|
      if @contract_type.save
        format.html { redirect_to contract_types_path, notice: 'El tipo de contrato fue creada exitosamente.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    authorize @contract_type

    respond_to do |format|
      if @contract_type.update(contract_type_params)
        format.html { redirect_to contract_types_path, notice: 'El tipo de contrato fue actualizada exitosamente.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    authorize @contract_type
    @contract_type.destroy
    respond_to do |format|
      format.html { redirect_to contract_types_url, notice: 'El tipo de contrato fue eliminada exitosamente.' }
    end
  end

  private

  def set_contract_type
    @contract_type = ContractType.find(params[:id])
  end

  def contract_type_params
    params.require(:contract_type).permit(:abbreviation, :name)
  end
end
