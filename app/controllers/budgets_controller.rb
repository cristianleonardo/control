class BudgetsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_contract
  before_action :set_budget, only: [:edit, :update, :destroy]
  before_action :set_current_query, only: [:edit, :index, :new]
  before_action :set_current_page, only: [:edit, :index, :new]

  def index
    @budgets = @contract.budgets.includes(:funds, :certificate)
    authorize @budgets
  end

  def new
    @budget = @contract.budgets.new
    authorize @budget
  end

  def edit
    authorize @budget
  end

  def create
    @budget = @contract.budgets.new(budget_params)
    authorize @budget

    respond_to do |format|
      if @budget.save
        format.html { redirect_to edit_contract_budget_path(@contract, @budget, query: params[:query], page: params[:page]), notice: 'El presupuesto fue creado exitosamente.' }
      else
        format.html { redirect_to contract_budgets_path(@contract, query: params[:query], page: params[:page]), alert: @budget.errors.messages[:reserva][0] }

      end
    end
  end

  def update
    authorize @budget

    respond_to do |format|
      if @budget.update(budget_params)
        format.html { redirect_to contract_budgets_path(@contract, query: params[:query], page: params[:page]), notice: 'El presupuesto fue actualizado exitosamente.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    authorize @budget
    @budget.destroy
    respond_to do |format|
      exp = 0
      @budget.funds.each do |f|
        exp += 1 if f.expenditures.any?
      end
      if @budget.funds.sum(:value) == 0 && exp == 0 && @budget.errors.details.empty?
        format.html { redirect_to contract_budgets_path(@contract, query: params[:query], page: params[:page]), notice: 'El presupuesto fue eliminado exitosamente.' }
      else
      format.html { redirect_to contract_budgets_path(@contract, query: params[:query], page: params[:page]), alert: " El certificado #{@budget.certificate.number} para el contrato #{@contract.process_number} no puede ser eliminado porque ya tiene presupuesto asignado o pagos creados"}
      end

    end
  end

  private

  def default_url_options(options={})
    { query1: params[:query1], query2: params[:query2], query3: params[:query3] }
  end

  def set_current_page
    @current_page = params[:page]
  end

  def set_current_query
    @current_query = params[:query]
  end

  def set_contract
    @contract = Contract.find(params[:contract_id])
  end

  def set_budget
    @budget = Budget.find(params[:id])
  end

  def budget_params
    params.require(:budget).permit(
      :contract_id, :certificate_id, :funds_attributes => [
        :id, :value
      ]
    )
  end
end
