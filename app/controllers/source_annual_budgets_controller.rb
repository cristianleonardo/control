class SourceAnnualBudgetsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_annual_budget
  before_action :set_source_annual_budget, only: [:edit, :update, :destroy]

  def index
    unless params[:query]
      @source_annual_budgets = @annual_budget.source_annual_budget.all.page(params[:page])
    else
      @source_annual_budgets = @annual_budget.source_annual_budget.basic_search(params[:query]).page(params[:page])
    end
  end

  def new
    @source_annual_budget = @annual_budget.source_annual_budget.new
  end

  def edit
  end

  def create
    @source_annual_budget = @annual_budget.source_annual_budget.new(source_annual_budget_params)
     respond_to do |format|
      if @source_annual_budget.save
        format.html { redirect_to annual_budget_source_annual_budgets_path(page: params[:page]), notice: 'El comprometido fue creado exitosamente.' }
      else
        format.html { redirect_to new_annual_budget_source_annual_budget_path(page: params[:page]), alert: 'El comprometido no pudo ser creado.' }
      end
    end
  end

  def update
    respond_to do |format|
      if @source_annual_budget.update(source_annual_budget_params)
        format.html { redirect_to annual_budget_source_annual_budgets_path(page: params[:page]), notice: 'El comprometido fue actualizado exitosamente.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @source_annual_budget.destroy
    respond_to do |format|
      format.html { redirect_to annual_budget_source_annual_budgets_path, notice: 'El comprometido fue eliminado exitosamente.' }
    end
  end

  private

  def set_annual_budget
    @annual_budget = AnnualBudget.find(params[:annual_budget_id])
  end

  def set_source_annual_budget
    @source_annual_budget = SourceAnnualBudget.find(params[:id])
  end

  def source_annual_budget_params
    params.require(:source_annual_budget).permit(
      :compromised_amount,
      :source_id,
      :annual_budget_id
      )
  end
end
