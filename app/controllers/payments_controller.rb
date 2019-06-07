class PaymentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_payment, only: [:edit, :update, :destroy, :expenditures, :withholdings, :concile_payment, :update_payment_conciliation]
  before_action :set_current_page, only: [:new, :edit, :expenditures, :withholdings, :concile_payment]
  cache_sweeper :payment_sweeper
  caches_action :index, :if => Proc.new { params[:page].nil? && session[:payments_hash].empty? && flash.empty?}

  def index
    unless session[:payments_hash].blank?
      @payments = Payment.payments_search(session[:payments_hash]).order(:date).page(params[:page])
    else
      @payments = Payment.order(date: :desc).page(params[:page]).includes(:contract)
    end
    authorize @payments
  end

  def new
    @payment = Payment.new(contract_id: params[:contract_id])
    authorize @payment
  end


  def edit
    authorize @payment
  end

  def create
    @payment = Payment.new(payment_params)
    authorize @payment
    respond_to do |format|
      if @payment.save(context: :payment_setup)
        # format.html { redirect_to payments_path(query: params[:query], page: params[:page]), notice: 'El Pago fue creado exitosamente.' }
        format.html { render :edit, query: params[:query], page: params[:page] }
      else
        format.html { redirect_to new_payment_path(query: params[:query], page: params[:page]), alert: @payment.errors.messages[:presupuesto][0] }
      end
    end
  end

  def update
    authorize @payment
    return_path = params[:payment][:return_path].present? ? params[:payment][:return_path] : payments_path(query: params[:query], page: params[:page])
    @payment.attributes = payment_params
    respond_to do |format|
        if @payment.save(context: :payment_setup)
          format.html { redirect_to return_path, notice: 'El Pago fue actualizado exitosamente.' }
        else
          if @payment.errors.messages[:"withholdings.retenciones"].any?
            format.html {redirect_to withholdings_payment_path, alert: "#{@payment.errors.messages[:"withholdings.retenciones"][0]}"}
          else
            format.html { redirect_to edit_payment_path, alert: "#{@payment.errors.messages[:presupuesto][0]} \n #{@payment.errors.messages[:fondos][0]}"  }
          end
        end
      end
  end

  def destroy
    authorize @payment
    @payment.destroy
    respond_to do |format|
      format.html { redirect_to payments_path(query: params[:query], page: params[:page]), notice: 'El Pago fue eliminado exitosamente.' }
    end
  end

  def withholdings
    @withholdings = @payment.withholdings.includes(:tax)
  end

  def expenditures
  end

  def concile_payment
  end

  def update_payment_conciliation
    @payment.attributes = payment_params
    @payment.conciled = true
    @payment.state = 'Conciliado'
    respond_to do |format|
      if @payment.save
        format.html { redirect_to payments_path(query: params[:query], page: params[:page]), notice: 'El Pago fue conciliado exitosamente.' }
      else
        format.html { render :concile_payment }
      end
    end
  end

  def search
    session[:payments_hash] = search_params
    redirect_to payments_path
  end

  def clean
    session[:payments_hash] = {}
    redirect_to payments_path
  end

  private


  def set_current_page
    @current_page = params[:page]
  end

  def search_params
    params.permit(:code, :st_date, :ed_date, :vat, :contract_id,
                :invoice_number, :state, :payment_type, :prepayment, :contractor).delete_if {|key, value| value.blank?}
  end




  def set_payment
    @payment = Payment.find(params[:id])
  end

  def payment_params
    params.require(:payment).permit(
      :contract_id,
      :code,
      :payment_type,
      :value,
      :prepayment_appliance,
      :vat,
      :vat_percentage,
      :date,
      :conciled_date,
      :observations,
      :invoice_number,
      :prepayment,
      expenditures_attributes: [:id, :value, :original_value, :prepayment_amortization],
      withholdings_attributes: [:percentage, :id, :base_value, :value, :_destroy, :tax_id]
    )
  end
end
