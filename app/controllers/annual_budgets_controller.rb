class AnnualBudgetsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_annual_budget, only: [:edit, :update, :destroy]
  cache_sweeper :annual_budget_sweeper

  def index
    unless params[:query]
      @annual_budgets = AnnualBudget.all.page(params[:page])
    else
      @annual_budgets = AnnualBudget.all.page(params[:page]).basic_search(params[:query]).page(params[:page]).order(:paei_year)
    end
  end

  def new
    @annual_budget = AnnualBudget.new
    authorize @annual_budget
  end

  def edit
    authorize @annual_budget
  end

  def create
    @annual_budget = AnnualBudget.new(annual_budget_params)
    authorize @annual_budget
     respond_to do |format|
      if @annual_budget.save
        format.html { redirect_to annual_budgets_path(page: params[:page]), notice: 'El PAEI fue creado exitosamente.' }
      else
        format.html { redirect_to new_annual_budget_path(page: params[:page]), alert: 'El PAEI no pudo ser creado.' }
      end
    end
  end

  def update
    authorize @annual_budget
    respond_to do |format|
      if @annual_budget.update(annual_budget_params)
        format.html { redirect_to annual_budgets_path(page: params[:page]), notice: 'El PAEI fue actualizado exitosamente.' }
      else
        format.html { render :edit, alert: "El paei no pudo ser actualizado" }
      end
    end
  end

  def destroy
    authorize @annual_budget
    @annual_budget.destroy
    respond_to do |format|
      format.html { redirect_to annual_budgets_path, notice: 'El PAEI fue eliminado exitosamente.' }
    end
  end

  private

  def set_annual_budget
    @annual_budget = AnnualBudget.find(params[:id])
  end

  def annual_budget_params
    params.require(:annual_budget).permit(
      :paei_year,
      :description
      )
  end
end
