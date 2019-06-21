class ReportsController < ApplicationController
  before_action :authenticate_user!

  def index

  end

  def withholdings
    start_date = params[:start_date]
    end_date = params[:end_date]
    mail = ReportsMailer.withholdings_report(current_user.id, start_date, end_date)
    mail.deliver_later

    redirect_to reports_path, notice: 'El reporte esta siendo generado y pronto sera enviado a su correo electronico' 

  end

  def financial
    start_date = params[:start_date]
    end_date = params[:end_date]

    mail = ReportsMailer.financial_report(current_user.id, start_date, end_date)
    mail.deliver_later

    redirect_to reports_path, notice: 'El reporte esta siendo generado y pronto sera enviado a su correo electronico' 
  end

  def pda
    start_date = params[:start_date]
    end_date = params[:end_date]

    mail = ReportsMailer.pda_report(current_user.id, start_date, end_date)
    mail.deliver_later

    redirect_to reports_path, notice: 'El reporte esta siendo generado y pronto sera enviado a su correo electronico' 

  end

  def cdr_without_contract
    start_date = params[:start_date]
    end_date = params[:end_date]
    mail = ReportsMailer.cdr_without_contract_report(current_user.id, start_date, end_date)
    mail.deliver_later

    redirect_to reports_path, notice: 'El reporte esta siendo generado y pronto sera enviado a su correo electronico' 
  end

  def available_balance_contract
    start_date = params[:start_date]
    end_date = params[:end_date]
    mail = ReportsMailer.available_balance_contract_report(current_user.id, start_date, end_date)
    mail.deliver_later

    redirect_to reports_path, notice: 'El reporte esta siendo generado y pronto sera enviado a su correo electronico' 
  end

  def subcomponent_and_source
    start_date = params[:start_date]
    end_date = params[:end_date]
    mail = ReportsMailer.subcomponent_and_source_report(current_user.id, start_date, end_date)
    mail.deliver_later

    redirect_to reports_path, notice: 'El reporte esta siendo generado y pronto sera enviado a su correo electronico' 
  end

  def design_mod
    start_date = params[:start_date]
    end_date = params[:end_date]
    mail = ReportsMailer.design_mod_report(current_user.id, start_date, end_date)
    mail.deliver_later

    redirect_to reports_path, notice: 'El reporte esta siendo generado y pronto sera enviado a su correo electronico' 
  end

  def fia
    year = params[:year]
    mail = ReportsMailer.fia_report(current_user.id, year)
    mail.deliver_later

    redirect_to reports_path, notice: 'El reporte esta siendo generado y pronto sera enviado a su correo electronico'     
  end

  def taxes_by_municipio
    start_date = params[:start_date]
    end_date = params[:end_date]
    mail = ReportsMailer.taxes_by_municipio_report(current_user.id, start_date, end_date)
    mail.deliver_later

    redirect_to reports_path, notice: 'El reporte esta siendo generado y pronto sera enviado a su correo electronico'
  end

  private

  def batch_of_payments(start_date, end_date)
    Payment.where("date >= :start_date AND date <= :end_date", {start_date: start_date, end_date: end_date}).order(date: :asc).each_instance(block_size: 500).each_slice(500).flat_map do |batch_of_payments| 
      ActiveRecord::Associations::Preloader.new.preload(batch_of_payments, {contract: :contractor, withholdings: {}, expenditures: {fund: [{budget: :certificate}, {designate: :source}]}})  
      batch_of_payments 
    end
  end

end
