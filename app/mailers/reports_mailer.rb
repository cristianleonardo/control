class ReportsMailer < ActionMailer::Base

   add_template_helper(ReportsHelper)

  def withholdings_report(user_id, st_date, ed_date)
    @user = User.find(user_id)
    @start_date = st_date
    @end_date = ed_date
    withholdings_operations(st_date, ed_date)
    xlsx = render_to_string layout: false, handlers: [:axlsx], formats: [:xlsx], template: "reports/withholdings", locals: {withholdings_names: @withholdings_names, months: @months}
    attachment = Base64.encode64(xlsx)
    attachments["Reporte_de_impuestos(#{st_date}-#{ed_date}).xlsx"] = {mime_type: Mime[:xlsx], content: attachment, encoding: 'base64'}
    mail(   :to      => "#{@user.email}",
            :subject => "Reporte de impuestos del #{st_date} al #{ed_date}"
    ) do |format|
      format.html
    end
  end

  def financial_report(user_id, st_date, ed_date)
    @user = User.find(user_id)
    @start_date = st_date
    @end_date = ed_date
    xlsx = render_to_string layout: false, handlers: [:axlsx], formats: [:xlsx], template: "reports/financial", locals: {start_date: @st_date, end_date: @ed_date}
    attachment = Base64.encode64(xlsx)
    attachments["Reporte_financiero(#{st_date}-#{ed_date}).xlsx"] = {mime_type: Mime[:xlsx], content: attachment, encoding: 'base64'}
    mail(   :to      => "#{@user.email}",
            :subject => "Reporte financiero del #{st_date} al #{ed_date}"
    ) do |format|
          format.html
    end
  end

  def pda_report(user_id, st_date, ed_date)
    @user = User.find(user_id)
    @start_date = st_date
    @end_date = ed_date
    pda_operations(st_date, ed_date)
    xlsx = render_to_string layout: false, handlers: [:axlsx], formats: [:xlsx], template: "reports/pda", locals: {contracts_by_source: @contracts_by_source, certificates: @certificates, sources_names: @sources_names, payments_by_cdr: @payments_by_cdr}
    attachment = Base64.encode64(xlsx)
    attachments["Reporte_PDA(#{st_date}-#{ed_date}).xlsx"] = {mime_type: Mime[:xlsx], content: attachment, encoding: 'base64'}
    mail(   :to      => "#{@user.email}",
            :subject => "Reporte PDA del #{st_date} al #{ed_date}"
    ) do |format|
          format.html
    end
  end

  def cdr_without_contract_report(user_id, st_date, ed_date)
    @user = User.find(user_id)
    @start_date = st_date
    @end_date = ed_date
    cdr_without_contract_operations(st_date, Date.parse(ed_date).end_of_day)
    xlsx = render_to_string layout: false, handlers: [:axlsx], formats: [:xlsx], template: "reports/cdr_without_contract", locals: {}
    attachment = Base64.encode64(xlsx)
    attachments["Reporte_cdr_sin_contratos(#{st_date}-#{ed_date}).xlsx"] = {mime_type: Mime[:xlsx], content: attachment, encoding: 'base64'}
    mail(   :to      => "#{@user.email}",
            :subject => "Reporte CDR sin contratos del #{st_date} al #{ed_date}"
    ) do |format|
          format.html
    end
  end

  def available_balance_contract_report(user_id, st_date, ed_date)
    @user = User.find(user_id)
    @start_date = st_date
    @end_date = ed_date
    available_balance_contract_operations(st_date, Date.parse(ed_date).end_of_day)
    xlsx = render_to_string layout: false, handlers: [:axlsx], formats: [:xlsx], template: "reports/available_balance_contract", locals: {certificates: @certificates, designates: @designates}
    attachment = Base64.encode64(xlsx)
    attachments["Reporte_saldo_por_contratar(#{st_date}-#{ed_date}).xlsx"] = {mime_type: Mime[:xlsx], content: attachment, encoding: 'base64'}
    mail(   :to      => "#{@user.email}",
            :subject => "Reporte de saldo por contratar del #{st_date} al #{ed_date}"
    ) do |format|
          format.html
    end    
  end

  def subcomponent_and_source_report(user_id, st_date, ed_date)
    @user = User.find(user_id)
    @start_date = st_date
    @end_date = ed_date
    @certificates = Certificate.where(limit_date: @start_date..Date.parse(@end_date).end_of_day).order(limit_date: :desc)
    xlsx = render_to_string layout: false, handlers: [:axlsx], formats: [:xlsx], template: "reports/subcomponent_and_source", locals: {certificates: @certificates}
    attachment = Base64.encode64(xlsx)
    attachments["Reporte_subcomponente_fuente(#{st_date}-#{ed_date}).xlsx"] = {mime_type: Mime[:xlsx], content: attachment, encoding: 'base64'}
    mail(   :to      => "#{@user.email}",
            :subject => "Reporte de subcomponente y fuente del #{st_date} al #{ed_date}"
    ) do |format|
          format.html
    end    
  end

  def design_mod_report(user_id, st_date, ed_date)
    @user = User.find(user_id)
    @start_date = st_date
    @end_date = ed_date
    @certificates = Certificate.where(limit_date: @start_date..Date.parse(@end_date).end_of_day).order(:number).includes(designates: [:transactions, :funds])
    @payments = Payment.where(contract_id: Budget.where(certificate_id: @certificates.pluck(:id)).pluck(:contract_id)).includes(:withholdings, :expenditures)
    xlsx = render_to_string layout: false, handlers: [:axlsx], formats: [:xlsx], template: "reports/design_mod", locals: {}
    attachment = Base64.encode64(xlsx)
    attachments["Reporte_diseño_mod(#{st_date}-#{ed_date}).xlsx"] = {mime_type: Mime[:xlsx], content: attachment, encoding: 'base64'}
    mail(   :to      => "#{@user.email}",
            :subject => "Reporte diseño mod del #{st_date} al #{ed_date}"
    ) do |format|
          format.html
    end
  end

  def taxes_by_municipio_report(user_id, st_date, ed_date)
    @user = User.find(user_id)
    @start_date = st_date
    @end_date = ed_date
    taxes_by_municipio_operations(st_date, ed_date)
    xlsx = render_to_string layout: false, handlers: [:axlsx], formats: [:xlsx], template: "reports/taxes_by_municipio", locals: {}
    attachment = Base64.encode64(xlsx)
    attachments["Reporte_impuestos_por_municipio(#{st_date}-#{ed_date}).xlsx"] = {mime_type: Mime[:xlsx], content: attachment, encoding: 'base64'}
    mail(   :to      => "#{@user.email}",
            :subject => "Reporte de impuestos por municipio del #{st_date} al #{ed_date}"
    ) do |format|
          format.html
    end
  end

  def fia_report(user_id, year)
    @user = User.find(user_id)
    @year = year
    annual_budgets_id = AnnualBudget.where(paei_year: @year)
    @certificates = Certificate.where(annual_budget_id: annual_budgets_id)
    xlsx = render_to_string layout: false, handlers: [:axlsx], formats: [:xlsx], template: "reports/fia", locals: {}
    attachment = Base64.encode64(xlsx)
    attachments["Reporte_FIA(#{year}).xlsx"] = {mime_type: Mime[:xlsx], content: attachment, encoding: 'base64'}
    mail(   :to      => "#{@user.email}",
            :subject => "Reporte FIA por municipio de #{year}"
    ) do |format|
          format.html
    end
  end

  private

  def withholdings_operations(start_date, end_date)
    @months = []
    payments_month = []
    last_payment = nil
    @payments = batch_of_payments(start_date, end_date)
      #@payments = Payment.where("date >= :start_date AND date <= :end_date", {start_date: params[:start_date], end_date: params[:end_date]}).order(date: :asc).find_in_batches(batch_size: 100)
      @payments.each do |payment|
        if last_payment.nil? || payment.date.month == last_payment.date.month
          payments_month.push(payment)
        else
          @months.push(payments_month)
          payments_month = []
          payments_month.push(payment)
        end
        last_payment = payment
        payment == @payments.last ?  @months.push(payments_month) : nil
      end

    @withholdings_names = Withholding.select("DISTINCT abbreviation, percentage")
  end

  def pda_operations(start_date, end_date)
    sql = <<-eos
      SELECT DISTINCT certificates.id as certificado, designates.certificate_id, (SELECT SUM(designates.value)  FROM designates WHERE designates.certificate_id = certificates.id ) AS cvalue, contracts.id AS contract_id, certificates.number AS certi_number, contracts.process_number, (SELECT string_agg(sources.name, ' - ')
      FROM sources, designates
      WHERE sources.id = designates.source_id and designates.certificate_id = certificates.id ) AS sname, contracts.id, contracts.contract_number, contracts.initial_value, contracts.start_date AS date_from, contracts.contractor_id, contracts.ending_date, contracts.term_days, contracts.term_months, contracts.contractual_object, contractors.id, contractors.name AS contractor_name, contractors.document_number, (SELECT SUM(expenditures.value) FROM payments, expenditures WHERE payments.contract_id = contracts.id AND payments.id = expenditures.payment_id) AS contract_pay FROM certificates, designates, budgets, contracts, contractors WHERE certificates.id = budgets.certificate_id AND designates.certificate_id = certificates.id AND contracts.id = budgets.contract_id AND contracts.contractor_id = contractors.id AND certificates.certificate_type = 'CDR' AND contracts.start_date >= ? and contracts.ending_date <= ?
    eos

    @contracts_by_source = Certificate.find_by_sql([sql, start_date, end_date])
    @certificates = Certificate.where("initial_date >= :start_date AND initial_date <= :end_date AND certificate_type = 'CDR'", {start_date: start_date, end_date: end_date})
    @sources_names = Source.select("name").includes(:certificates)
    @payments_by_cdr = Expenditure.all.includes({:fund => {:budget => :certificate } },{:fund => {:designate => :source }}, {:payment =>{:contract => :contractor} } )
    
  end

  def cdr_without_contract_operations(start_date, end_date)
    certificates = Certificate.where(limit_date: start_date..end_date).order(:number)
    @certificates = []
    certificates.each do |certificate|
      unless certificate.budgets.any?
        @certificates.push([certificate[:number], "#{certificate[:expense_concept]} - #{certificate[:project_name]}",
          certificate.designates, certificate.designates.sum(:value), certificate[:initial_date], certificate[:limit_date], certificate[:state]])
      end
    end
  end

  def available_balance_contract_operations(start_date, end_date)
    certificates = Certificate.where(limit_date: start_date..end_date).order(limit_date: :desc).includes(:designates, :budgets)
    @certificates = []
    @designates = []
    certificates.each do |certificate|
      sub_component = certificate.sub_component.name
      @designates.push([certificate.designates, certificate.budgets])
      @certificates.push([certificate[:number], certificate[:limit_date], sub_component, certificate[:expense_concept], certificate[:minute_id]])
    end
  end

  def taxes_by_municipio_operations(start_date, end_date)
    cities = City.pluck(:name).uniq
    @cities_name = []
    cities.each_with_index do |city, index|
      if city.end_with?("Cúcuta","Cácota","Hacarí","Herrán")
        name = city.split(" ")[-1]
        @cities_name.push([city, name, name.mb_chars.decompose.scan(/[a-zA-Z0-9]/).join])
      else
        @cities_name.push([city])
      end
    end
    @certificates = Certificate.where(limit_date: start_date..end_date).uniq.order(:number)
  end

  def batch_of_payments(start_date, end_date)
    Payment.where("date >= :start_date AND date <= :end_date", {start_date: start_date, end_date: end_date}).order(date: :asc).each_instance(block_size: 500).each_slice(500).flat_map do |batch_of_payments|
      ActiveRecord::Associations::Preloader.new.preload(batch_of_payments, {contract: :contractor, withholdings: {}, expenditures: {fund: [{budget: :certificate}, {designate: :source}]}})
      batch_of_payments
    end
  end

end
