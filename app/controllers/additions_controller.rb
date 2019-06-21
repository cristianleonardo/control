class AdditionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_contract
  before_action :set_addition, only: [:edit, :update, :destroy]
  before_action :set_current_query, only: [:edit, :index, :new]
  before_action :set_current_page, only: [:edit, :index, :new]

  def index
    @additions = @contract.additions.all
  end

  def new
    @addition = @contract.additions.new
  end

  def edit
  end

  def create
    @addition = @contract.additions.new(addition_params)
    respond_to do |format|
      if @addition.save
        format.html { redirect_to contract_additions_path(@contract, query: params[:query], page: params[:page]), notice: 'La adición fue creado exitosamente.' }
      else
       format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @addition.update(addition_params)
        format.html { redirect_to contract_additions_path(@contract, query: params[:query], page: params[:page]), notice: 'La adición fue actualizada exitosamente.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @addition.destroy
    respond_to do |format|
      format.html { redirect_to contract_additions_path(@contract, query: params[:query], page: params[:page]), notice: 'La adición fue eliminada exitosamente.' }
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

  def set_addition
    @addition = Addition.find(params[:id])
  end

  def addition_params
    params.require(:addition).permit(
      :contract_id,
      :number,
      :addition_value,
      :addition_date,
      :value_addition,
      :term_addition,
      :addition_type,
      :restart_suspension_date,
      :restart_suspension_reason
    )
  end
end
