class ContractsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_contract, only: [:edit, :show, :update, :destroy]
  before_action :set_current_page, only: [:edit, :show, :new]
  cache_sweeper :contract_sweeper
  caches_action :index, :if => Proc.new { params[:page].nil? && session[:contracts_hash].empty? && flash.empty?}

  def index
    unless session[:contracts_hash].blank?
      @contracts = Contract.contracts_search(session[:contracts_hash]).includes(:contractor, :budgets).order(process_number: :desc).page(params[:page])
    else
      @contracts = Contract.page(params[:page]).order(process_number: :desc)
    end
    authorize @contracts
  end

  def new
    @contract = Contract.new
    authorize @contract
  end

  def edit
    authorize @contract
    @medias = @contract.medias
  end

  def show
    authorize @contract
    @current_query = params[:query]
  end

  def create
    @contract = ::Contract.new(contract_params)
    authorize @contract

    respond_to do |format|
      if @contract.save
        format.html { redirect_to contracts_path(page: params[:page]), notice: 'El contrato fue creado exitosamente.' }
      else
        format.html { redirect_to new_contract_path(page: params[:page]), alert: @contract.errors.messages[:contractors][0] || "No fue psobile registrar el contrato"}
      end
    end
  end

  def update
    authorize @contract

    respond_to do |format|
      if @contract.update(contract_params)
        format.html { redirect_to contracts_path(page: params[:page], notice: 'El contrato fue actualizado exitosamente.') }
      else
        format.html { redirect_to edit_contract_path, alert: @contract.errors.messages[:contractors][0] || "No fue psobile actualizar el contrato"}
      end
    end
  end

  def destroy
    authorize @contract
    @contract.destroy

    respond_to do |format|
      if @contract.errors.details.empty?
        format.html { redirect_to contracts_url(page: params[:page]), notice: 'El contrato fue eliminado exitosamente.' }
      else
        format.html { redirect_to contracts_path(page: params[:page]), alert: "El contrato #{@contract.contract_number}  no puede ser eliminado porque ya tiene presupuesto asignado"}
      end
      format.html { redirect_to contracts_url(page: params[:page]), notice: 'El contrato fue eliminado exitosamente.' }
    end
  end

  def report
    @contracts = Contract.contracts_search(session[:contracts_hash])

    respond_to do |format|
      format.xlsx{
        response.headers['Content-Disposition'] = 'attachment; filename="reporte_contractos.xlsx"'
      }
    end
  end

  def search
    session[:contracts_hash] = search_params
    redirect_to contracts_path(page: params[:page])
  end

  def clean
    session[:contracts_hash] = {}
    redirect_to contracts_path
  end


  private

  def search_params
    params.permit(:contractor_id, :keyword, :st_date, :ed_date, :certificate_id, :state,
                  :mode, :contract_type_id, :interventor_contractor_id,
                  :supervisor_contractor_id, :city_id, source_id: []).delete_if {|key, value| value.blank? }
  end

  def set_current_page
    @current_page = params[:page]
  end

  def set_contract
    @contract = Contract.find(params[:id])
  end

  def contract_params
    params.require(:contract).permit(
      :contract_number,
      :contractual_object,
      :observations,
      :suscription_date,
      :start_date,
      :settlement_date,
      :value,
      :prepayment,
      :city_id,
      :mode,
      :state,
      :term_months,
      :term_days,
      :interventor_contractor_id,
      :supervisor_contractor_id,
      :contractor_id,
      :contract_type_id,
      :process_number,
      :opening_date,
      :end_date,
      :award_date
     )
  end
end
