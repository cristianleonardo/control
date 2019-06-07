class TaxesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_tax, only: [:edit, :update, :destroy]

  def index
    @taxes = Tax.all
    authorize @taxes
  end

  def new
    @tax = Tax.new
    authorize @tax
  end

  def edit
    authorize @tax
  end

  def create
    @tax = Tax.new(tax_params)
    authorize @tax

    respond_to do |format|
      if @tax.save
        format.html { redirect_to taxes_path, notice: 'El impuesto fue creado exitosamente.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    authorize @tax

    respond_to do |format|
      if @tax.update(tax_params)
        format.html { redirect_to taxes_path, notice: 'El impuesto fue actualizado exitosamente.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    authorize @tax
    @tax.destroy
    respond_to do |format|
      format.html { redirect_to taxes_url, notice: 'El impuesto fue eliminado exitosamente.' }
    end
  end

  private

  def set_tax
    @tax = Tax.find(params[:id])
  end

  def tax_params
    params.require(:tax).permit(
      :abbreviation,
      :description,
      :initial_date,
      :end_date,
      :percentage,
      :city_id,
      contract_types: [],
      contractor_types: []
    )
  end
end
