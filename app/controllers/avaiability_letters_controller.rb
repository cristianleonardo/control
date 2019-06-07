class AvaiabilityLettersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_committee_minute, :set_annual_budget
  before_action :set_letter, only: [:edit, :update, :destroy]
  cache_sweeper :avaiability_letter_sweeper

  def index
    unless params[:query]
      @avaiability_letters = @committee_minute.avaiability_letters.all.page(params[:page])
    else
      @avaiability_letters = @committee_minute.avaiability_letters.basic_search(params[:query]).page(params[:page]).order(:date)
    end
  end

  def new
    @avaiability_letter = @committee_minute.avaiability_letters.new
  end

  def edit
  end

  def create
    @avaiability_letter = @committee_minute.avaiability_letters.new(avaiability_letters_params)

     respond_to do |format|
      if @avaiability_letter.save
        format.html { redirect_to annual_budget_committee_minute_avaiability_letters_path(page: params[:page]), notice: 'La carta fue creada exitosamente.' }
      else
        format.html { redirect_to new_annual_budget_committee_minute_path(page: params[:page]), alert: 'La carta no pudo ser creada.' }
      end
    end
  end

  def update
    respond_to do |format|
      if @avaiability_letter.update(avaiability_letters_params)
        format.html { redirect_to annual_budget_committee_minute_avaiability_letters_path(page: params[:page]), notice: 'La carta fue actualizada exitosamente.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @avaiability_letter.destroy
    respond_to do |format|
      format.html { redirect_to annual_budget_committee_minute_avaiability_letters_path, notice: 'La carta fue eliminada exitosamente.' }
    end
  end

  private

  def set_annual_budget
    @annual_budget = AnnualBudget.find(params[:annual_budget_id])
  end

  def set_committee_minute
    @committee_minute = CommitteeMinute.find(params[:committee_minute_id])
  end

  def set_letter
    @avaiability_letter = AvaiabilityLetter.find(params[:id])
  end

  def avaiability_letters_params
    params.require(:avaiability_letter).permit(
      :annual_budget_id,
      :committee_minute_id,
      :paei_year,
      :title,
      :subject,
      :date,
      :code,
      :certificate_ids
      )
  end

end
