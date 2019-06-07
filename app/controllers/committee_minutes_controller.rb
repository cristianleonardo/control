class CommitteeMinutesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_annual_budget
  before_action :set_minute, only: [:edit, :update, :destroy]
  cache_sweeper :committee_minute_sweeper

  def index
    unless params[:query]
      @committee_minutes = @annual_budget.committee_minutes.all.page(params[:page])
    else
      @committee_minutes = @annual_budget.committee_minutes.basic_search(params[:query]).page(params[:page]).order(:date)
    end
  end

  def new
    @committee_minute = @annual_budget.committee_minutes.new
  end

  def edit
  end

  def create
    @committee_minute = @annual_budget.committee_minutes.new(committee_minutes_params)

     respond_to do |format|
      if @committee_minute.save
        format.html { redirect_to annual_budget_committee_minutes_path(page: params[:page]), notice: 'El Acta fue creada exitosamente.' }
      else
        format.html { redirect_to new_annual_budget_committee_minute_path(page: params[:page]), alert: 'El Acta no pudo ser creada.' }
      end
    end
  end

  def update
    respond_to do |format|
      if @committee_minute.update(committee_minutes_params)
        format.html { redirect_to annual_budget_committee_minutes_path(page: params[:page]), notice: 'El Acta fue actualizada exitosamente.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @committee_minute.destroy
    respond_to do |format|
      format.html { redirect_to annual_budget_committee_minutes_path, notice: 'El Acta fue eliminada exitosamente.' }
    end
  end

  private

  def set_annual_budget
    @annual_budget = AnnualBudget.find(params[:annual_budget_id])
  end

  def set_minute
    @committee_minute = CommitteeMinute.find(params[:id])
  end

  def committee_minutes_params
    params.require(:committee_minute).permit(
      :annual_budget_id,
      :paei_year,
      :title,
      :description,
      :date,
      :code,
      :certificate_ids
      )
  end

end
