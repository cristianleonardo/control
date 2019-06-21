
module ReportsHelper
  def date_string(date_start, date_end)
    months = ["ENERO","FEBRERO","MARZO","ABRIL","MAYO","JUNIO","JULIO","AGOSTO","SEPTIEMBRE","OCTUBRE","NOVIEMBRE","DICIEMBRE"]
    array_date_start = date_start.split("-")
    array_date_end = date_end.split("-")

    string_date_start = "#{array_date_start[2].to_i} DE #{months[array_date_start[1].to_i - 1]}"
    string_date_end = "#{array_date_end[2].to_i} DE #{months[array_date_end[1].to_i - 1]}"
    string_date_complete = "#{string_date_start} DEL #{array_date_start[0]} AL #{string_date_end} DEL #{array_date_end[0]}"

    string_date = array_date_start[0] == array_date_end[0] ? "#{array_date_start[0]}(#{string_date_start} - #{string_date_end})" : string_date_complete
  end

  def cdr_without_contract_sources(designates)
    string_sources = ""
    sources_id = designates.where(source_id: Source.where('name NOT LIKE ?','%MUNICIPIO%').pluck(:id)).pluck(:source_id)
    sources_whithout_municipio = Source.where(id: sources_id).pluck(:name)
    source_municipio = designates.where(source_id: Source.where('name LIKE ?','%MUNICIPIO%').pluck(:id)).pluck(:source_id)
    size = sources_whithout_municipio.length - 1
    sources_whithout_municipio.each_with_index do |source, index|
      string_sources << source
      string_sources << ", " if index != size
    end
    string_sources << ", " if sources_whithout_municipio.any? && source_municipio.any?
    string_sources << "SGP MUNICIPIO" if source_municipio.any?
    string_sources
  end

  def design_mod_sheet_1_and_2
    certificates = @certificates
    values_rows = []
    value_row_merge = []
    @values_contract_column = []
    count_cell = 2
    count_cell_contract = 1
    array_count_designates = []
    count_designates = 0
    count_contracts = 0

    certificates.each do |certificate|
      index_contract = 0
      cell_start = count_cell + 1
      count_cell_contract = cell_start > 3 ? count_cell_contract : cell_start
      sub_component = certificate.sub_component
      component = sub_component.component
      designates = certificate.designates
      contracts_id = certificate.cached_budgets.pluck(:contract_id)
      contracts = Contract.where(id: contracts_id)

      value_sub_colum_left = [certificate.number, certificate.expense_concept]
      value_sub_colum_rigth = [certificate.state, component.name, sub_component.name, certificate.initial_date, certificate.limit_date]

      designates.each_with_index do |designate, index|
        count_designates += 1
        transactions = filter_collection(designate.transactions, :transaction_type, "subtract")
        value_transaction = sum_collection(transactions, :amount)
        last_date_transaction = transactions.sort_by(&:issue_date).last
        last_date_transaction = last_date_transaction ? last_date_transaction.issue_date : "N/A"
        designate_funds_value = sum_collection(designate.funds, :value)
        designate_available_value = designate.value - designate_funds_value
        value_row_balance = ['', designate_available_value]

        if index == 0
          values_rows << value_sub_colum_left + [designate.source.name, designate.value, designate_available_value] + value_sub_colum_rigth + value_row_balance + [value_transaction > 0 ? "SI" : "NO", designate.source.name, value_transaction, last_date_transaction]
        else
          values_rows << [''] * 2 + [designate.source.name, designate.value, designate_funds_value] + [''] * 5  + value_row_balance + ['', designate.source.name, value_transaction, last_date_transaction]
        end

        if index < contracts.length
          @values_contract_column << design_mod_sheet_2(count_cell_contract, contracts[index], designates, certificate, values_rows)
          count_cell_contract += 1
          count_contracts += 1
          index_contract = index
        else
          @values_contract_column << values_rows[-1][0..4] + ["NO ADICIÓN"] + values_rows[-1][6..7] + ['-'] * 7 + ["=M#{cell_start}-N#{cell_start}-O#{cell_start}"] + ['-'] * 12 + [''] + [''] * 8
          count_cell_contract += 1
        end
      end

      unless designates.any?
        values_rows << value_sub_colum_left + [''] * 3 + value_sub_colum_rigth + ['','N/A','N/A', 'N/A', 'N/A', 'N/A']
        @values_contract_column << values_rows[-1][0..4] + ["-"] + values_rows[-1][6..7] + ['-'] * 7 + ["=M#{cell_start}-N#{cell_start}-O#{cell_start}"] + ['-'] * 12 + [''] + [''] * 8
        count_cell_contract += 1
      else
        if index_contract + 1 < contracts.length
          index_contract = index_contract == 0 ? 1 : index_contract
          range = designates.length..(contracts.length - index_contract)
          rows = [[''] * 8]
          range.each do |i|
            @values_contract_column << design_mod_sheet_2(count_cell_contract, contracts[i], designates, certificate, rows)
            count_cell_contract += 1
            count_contracts += 1
          end
        end
      end

      cnt_designates = count_designates >= count_contracts ? count_designates : count_contracts
      cnt_designates = cnt_designates > 0 ? cnt_designates : 1
      cell_end = cell_start + cnt_designates - 1
      count_cell = cell_end
      value_row_merge << [cell_start, cell_end]
      array_count_designates << count_designates
      count_designates = 0
      count_contracts = 0
    end
    @merge_sheet_1 = merge_row(2, array_count_designates)
    @merge_sheet_2 = value_row_merge
    values_rows
  end

  def withholding_abbreviation_include_sum(withholdings, condition)
    withholdings.map {|w| w.value if (w.abbreviation || "").include?(condition)}.compact.inject(0,:+)
  end

  def sum_collection(collection, value)
    sum = 0
    collection.each {|c| sum += (c.public_send(value) || 0) }
    sum
  end

  def filter_collection(collection, value, condition)
    collection.map {|c| c if (c.public_send(value) || "").include?(condition)}.compact
  end

  def filter_number_collection(collection, value, condition)
    collection.map {|c| c if c.public_send(value) == condition }.compact
  end

  def design_mod_sheet_3_and_4(wb)
    payments = @payments
    @array_values_sheet_3 = wb.add_worksheet(name: "reporte de ordenes de pago")
    @array_values_sheet_4 = wb.add_worksheet(name: "reporte de impuestos")
    array_merge = []

    @array_values_sheet_3.add_row(["DESCRIPCION EMPRESA CONSOLIDADORA","MUNICIPIO","CLASE","No. ORDEN DE PAGO","FECHA","No. CONTRATO","No. CDR´S","FUENTES","NOMBRE DEL CONTRATISTA O BENEFICIARIO","NIT O CC BENEFICIARIO","DIRECCION","No. CUENTA","TIPO DE CUENTA ","BANCO","CONCEPTO DEL PAGO","VALOR BRUTO  PAGO","VLR RETENCIONES","VALOR OTROS DESCUENTOS"])

    @array_values_sheet_4.add_row(["MUNICIPIO","No. ORDEN DE PAGO","FECHA","No. CONTRATO","No. CDR´S","FUENTES","NOMBRE DEL CONTRATISTA O BENEFICIARIO","NIT O CC BENEFICIARIO","CONCEPTO DEL PAGO","VALOR BRUTO PAGO","VLR. IVA","VLR. RT. FTE","VLR. RT. IVA","VLR. RT. ICA","VLR. RETENCIONES","EST. H.E.M.", "EST. PRODES. PAG. TESO. DEP", "EST. PROFRONT. PAG. TESO. DEP.","EST. PROANCI. PAG. TESO. DEP","EST. PROCULT. DEP.","EST. PRODES. ACADM. CIENT. UNI. PUBLI.","CONTR. ESP. CONTRA. OBRA PUB.","AMORTIZACION-ANTICIPO","VLR. OTROS DESCUENTOS", "VALOR NETO DESEMBOLSO"])

    payments.each do |payment|
      expenditures = payment.expenditures.map {|c| c if c.value > 0 }.compact
      cdr = ""
      source = ""
      contract = payment.contract
      contractor = contract.contractor
      interventor = contract.interventor
      gross_value = payment.base_value + payment.vat_value

      #discounts_by_tax
      withholdings_cached = payment.withholdings
      withholdings_ICA = withholding_abbreviation_include_sum(withholdings_cached,"ICA")
      withholdings_source = withholding_abbreviation_include_sum(withholdings_cached,"Fuente")
      withholdings_IVA = withholding_abbreviation_include_sum(withholdings_cached,"IVA")

      discounts_by_tax = withholdings_ICA + withholdings_IVA + withholdings_source

      #other_discounts
      withholdings_academic = withholding_abbreviation_include_sum(withholdings_cached,"Académico")
      withholdings_HEM = withholding_abbreviation_include_sum(withholdings_cached,"H.E.M")
      withholdings_prodesarrollo = withholding_abbreviation_include_sum(withholdings_cached,"Prodesarrollo")
      withholdings_procultura = withholding_abbreviation_include_sum(withholdings_cached,"Procultura")
      withholdings_proanciano = withholding_abbreviation_include_sum(withholdings_cached,"Proanciano")
      withholdings_profronterizo = withholding_abbreviation_include_sum(withholdings_cached,"Profronterizo")
      withholdings_special = withholding_abbreviation_include_sum(withholdings_cached,"ESPECIAL")

      other_discounts = withholdings_academic + withholdings_HEM + withholdings_prodesarrollo + withholdings_procultura + withholdings_proanciano + withholdings_profronterizo + withholdings_special

      city = contract.city
      array_merge << expenditures.length

      expenditures.each_with_index do |expenditure, index|
        designate = expenditure.fund.designate
        certificate = designate.certificate
        source = designate.source
        document = "#{contractor.document_type} - #{contractor.document_number}"

        if index == 0
          interventor_name = interventor ? interventor.name : "-"
          contractor_name = contractor ? contractor.name : "-"
          @array_values_sheet_3.add_row([interventor_name, city.name, 'MUNICIPIO', payment.code, payment.date, contract.process_number, certificate.number, source.name, contractor_name, document,'N/A','N/A','N/A','N/A',certificate.expense_concept, gross_value, discounts_by_tax, other_discounts], widths: [40, :auto, :auto, 20, :auto, :auto, :auto, :auto, 43, 23])

          disbursement_value = gross_value - discounts_by_tax - other_discounts
          value_amortization = payment.prepayment? ? payment.value : payment.prepayment_appliance
          value_IVA = payment.vat ? payment.value * payment.vat_percentage : "-"
          @array_values_sheet_4.add_row([city.name, payment.code, payment.date, contract.process_number, certificate.number, source.name, contractor_name, document, certificate.expense_concept, gross_value, value_IVA, withholdings_source, withholdings_IVA ,withholdings_ICA, discounts_by_tax, withholdings_HEM, withholdings_prodesarrollo, withholdings_profronterizo, withholdings_proanciano, withholdings_procultura, withholdings_academic, withholdings_special, value_amortization, other_discounts, disbursement_value])
        else
          @array_values_sheet_3.add_row(['', '', '', '', '', '', certificate.number, source.name,'','','N/A','N/A','N/A','N/A','','','',''], widths: [40, :auto, :auto, 20, :auto, :auto, :auto, :auto, 43, 23])

          @array_values_sheet_4.add_row(['', '', '', '', certificate.number, source.name, '','', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', ''])
        end
      end
    end
    @merge_values = merge_row(1, array_merge)
  end

  def design_mod_sheet_2(cell_start, contract, designates, certificate, values_rows)
    budgets = filter_number_collection(contract.cached_budgets, :certificate_id, certificate[:id])
    funds_id = Fund.where(budget_id: budgets.pluck(:id)).pluck(:id)
    transactions = Transaction.where(transactionable_type: 'Fund', transactionable_id: funds_id)
    transactions_contract = filter_collection(transactions, :transaction_type, "subtract")
    transactions_add = transactions.map { |c| c if c.transaction_type == "add" }.compact
    additions_contract = sum_collection(transactions_add, :amount)
    transactions_add = transactions_add.map { |c| c if c.is_adittion }.compact
    true_additions_contract = sum_collection(transactions_add, :amount)
    value_transaction_contract = sum_collection(transactions_contract, :amount)
    is_addition = additions_contract > 0 ? "SI ADICIÓN" : "NO ADICIÓN"
    number_certificate = certificate[:number]
    addition_date = transactions_add.first.created_at if transactions_add.any?
    addition_type = transactions_add[0].addition.addition_type if transactions_add.any?
    formula_addition_balance_substract_rigth = "=AH#{cell_start}-AI#{cell_start}"
    formula_addition_balance_available_rigth = "=AH#{cell_start}-AI#{cell_start}-AJ#{cell_start}"
    column_cdr = values_rows[-1][0..4] + [is_addition] + values_rows[-1][6..7]

    values =  column_cdr + column_contract_sheet_2(cell_start, contract, additions_contract, true_additions_contract, value_transaction_contract, addition_date) + ['', is_addition.delete_suffix(" ADICIÓN"), number_certificate, addition_date, addition_type, additions_contract, true_additions_contract, formula_addition_balance_substract_rigth, formula_addition_balance_available_rigth]
  end

  def column_contract_sheet_2(cell_start, contract, additions_contract, true_additions_contract, value_transaction_contract, addition_date)
    process_number = contract.process_number
    contract_mode = CONTRACT_MODE.key(contract.mode.to_sym)
    contract_type = contract.contract_type.name
    contract_state = CONTRACT_STATES.key(contract.state.to_sym)
    contract_value = contract.cached_fetch_value
    contract_paid_value = sum_collection(contract.cached_payments, :value)
    formula_available_balance = "=M#{cell_start}-N#{cell_start}-O#{cell_start}"
    formula_addition_balance_substract_left = "=Q#{cell_start}-R#{cell_start}"
    formula_addition_balance_available_left = "=Q#{cell_start}-R#{cell_start}-S#{cell_start}"
    contractor = contract.contractor
    interventor = contract.interventor
    contractor_name = contractor ? contractor.name : "-"
    interventor_name = interventor ? interventor.name : "-"
    suscription_date = contract.suscription_date
    start_date = contract.start_date
    ending_date = contract.ending_date
    term_months = "#{contract.term_months}M" if contract.term_months > 0
    term_days = "#{contract.term_days}D" if contract.term_days > 0
    term_months_and_days = !term_days.blank? ? "#{term_months} Y #{term_days}" : term_months
    contractual_object = contract.contractual_object

    array_column = [process_number, contract_mode, contract_type, contract_state, contract_value, contract_paid_value, value_transaction_contract, formula_available_balance, additions_contract, true_additions_contract, formula_addition_balance_substract_left, formula_addition_balance_available_left, contractor_name, interventor_name, suscription_date, start_date, addition_date, ending_date, term_months_and_days, contractual_object]

    array_column
  end

  def merge_row(i, array_cnt)
    value_row_merge = []
    array_cnt.each do |row|
      cell_start = i + 1
      cell_end = i + (row > 0 ? row : 1)
      i = cell_end
      value_row_merge << [cell_start, cell_end]
    end
    value_row_merge
  end

  def hash_styles(bold, fmt, array_position)
    { b: bold, format_code: fmt, alignment: {vertical: :center, horizontal: :center, wrap_text: true}, border: { :style => :thin, :color => '000000', :name => :top, :edges => array_position}}
  end

  def value_source(designates_and_budgets)
    values = []
    available_value = []
    designate_query = []
    sources_whithout_municipio = Source.where('name NOT LIKE ?','%MUNICIPIO%').pluck(:id)
    sources_municipio = Source.where('name LIKE ?','%MUNICIPIO%').pluck(:id)
    designates = designates_and_budgets[0]
    budgets = designates_and_budgets[1]

    if designates
      sources_whithout_municipio.each do |source|
        designate_query = filter_number_collection(designates, :source_id, source)
        if designate_query.length > 0
          designate_sum_value = sum_collection(designate_query, :value)
          available_designates_value = designate_sum_value - Fund.where(budget_id: budgets.pluck(:id)).sum(:value)
          values.push(designate_sum_value)
          available_value.push(available_designates_value)
        else
          values.push('-')
          available_value.push('-')
        end
      end

      designate_query = designates.map {|c| c if sources_municipio.include?(c.source_id)}.compact

      if designate_query.length > 0
        designate_sum_value = sum_collection(designate_query, :value)
        available_designates_value = designate_sum_value - Fund.where(budget_id: budgets.pluck(:id)).sum(:value)
        values.push(designate_sum_value)
        available_value.push(available_designates_value)
      else
        values.push('-')
        available_value.push('-')
      end

    else
      available_value = ['-','-','-','-','-','-','-','-','-','-','-','-','-','-','-','-']
    end
    columns = values << available_value
    columns.flatten!
  end

  def name_sources
    sources = Source.where('name NOT LIKE ?','%MUNICIPIO%').pluck(:name)
    sources.push("RECURSOS MUNICIPIO")
    @name_sources = []
    sources.each do |source|
      unless source.include?("MUNICIPIO")|| source.include?("DE LA NACION")
        tmp = source.delete_prefix("RECURSOS REGALÍAS SGR ").delete_prefix("RECURSOS").delete_prefix("-")
        @name_sources.push(tmp)
      else
        @name_sources.push(source)
      end
    end
    @name_sources
  end

  def name_components_with_values
    components = Component.pluck(:id,:name)
    name_colums_components = []
    @index_row_total_components = []
    start_row = 2

    components.each_with_index do |component, index|
      sub_components = SubComponent.where(component_id: component[0]).pluck(:id, :name)
      number_component = index + 1
      start_row += 1
      start_row_formula = start_row + 1
      name_colums_components.push([number_component, component[1].upcase] + [''] * 9)

      sub_components.each_with_index do |sub_component, index|
        start_row += 1
        number_sub_component = "#{number_component}.#{index + 1}"
        name_colums_components.push([number_sub_component, sub_component[1], total_sub_component_by_sources(@name_sources, sub_component[0])].flatten + ["=SUM(C#{start_row}:J#{start_row})"])
      end

      name_colums_components.push(["TOTAL SUBCOMPONENTE #{number_component}", ""] + formulas_report_component("C".."K", "SUM", start_row_formula,  start_row))

      start_row += 1
      @index_row_total_components << start_row
    end
    name_colums_components
  end

  def formulas_report_component(range_letter, operation, first, last)
    array_formula = []
    range_letter.each do |character|
      array_formula << "=#{operation}(#{character}#{first}:#{character}#{last})"
    end
    array_formula
  end

  def formula_total_sum(range_letters,index_to_sum)
    array_formula = []
    string_formula = "="

    range_letters.to_a.each do |letter|
      index_to_sum.each_with_index do |index_row, index|
        string_formula += "#{letter}#{index_row}"
        string_formula += "+" if index != index_to_sum.length - 1
      end
      array_formula << string_formula
      string_formula = "="
    end
    array_formula
  end

  def total_sub_component_by_sources(sources, sub_component_id)
    certificates_id = @certificates.where(sub_component_id: sub_component_id)
    total_by_component = []
    sources.each do |code|
      sources_id = Source.where('name LIKE ?', "%#{code}%").pluck(:id)
      designates = Designate.where(source_id: sources_id, certificate_id: certificates_id)
      total_certificate = designates.sum(:value)
      total_by_component.push(total_certificate)
    end
    total_by_component
  end

  def withholdings_names_to_columns(withholdings_names)
    @values = ["ORDEN DE PAGO", "No. CDR", "FUENTE DE FINANCIACIÓN", "FECHA", "NOMBRE DEL CONTRATISTA", "VALOR A COBRAR", "VALOR ANTES DE IVA", "VALOR DEL IVA"]
    withholdings_names.each do |withh|
      @values.push("#{withh.abbreviation.mb_chars.upcase} - #{withh.percentage}")
    end
    return @values
  end

  def sources_names_to_columns(sources_names)
    values = ["CONCEPTO/VIGENCIA"]
    sources_names.each do |source|
      values.push(source.mb_chars.upcase)
    end
    values.push("TOTAL")
    return values
  end

  def payment_row_values(payment, withholdings_names)
    @payment_cdrs = ""
    @payment_sources = ""
    last_certificate = ""
    last_source = ""
    payment.cached_expenditures.each do |exp|
      if exp.value > 0 && !exp.fund.blank?
        if exp.fund.budget.certificate.number.to_s != @last_certificate
          @payment_cdrs = @payment_cdrs == "" ?  exp.fund.budget.certificate.number.to_s : @payment_cdrs + "," + exp.fund.budget.certificate.number.to_s
        end
        last_certificate = exp.fund.budget.certificate.number.to_s

        if exp.fund.designate.source.name != @last_source
          @payment_sources = @payment_sources == "" ?  exp.fund.designate.source.name : @payment_cdrs + "," + exp.fund.designate.source.name
        end
        last_source = exp.fund.designate.source.name
      end
    end

    values = [payment.code.to_s, @payment_cdrs, @payment_sources, payment.date.strftime("%Y/%m/%d"), payment.contract.contractor.name, payment.value, payment.base_value, payment.vat_value]
    values = values + ['-'] * withholdings_names.size
    payment.withholdings.each do |withh|
      i = @values.index("#{withh.abbreviation.mb_chars.upcase} - #{withh.percentage}")
      values[i] = withh.value 
      #withhold = payment.withholdings.map {|c| c.value if c.abbreviation == withh[0] && c.percentage == withh[1]}.compact.first
      #values.push(withhold.nil? ? "-" : withhold)
    end
    return values
  end

  def sum_payment_monthly(month, withholdings_names, sum_start, sum_stop)
    range = []
    array = ("A".."Z").to_a
    ("A".."Z").to_a.each do |l|
       array.map {|letter| range.push("#{l}#{letter}")}
    end
    letter_range = ("A".."Z").to_a + range
    values = ["","","","",""]
    formula_value = "=SUM(F#{sum_start}:F#{sum_stop})"
    formula_base_value = "=SUM(G#{sum_start}:G#{sum_stop})"
    formula_vat_value = "=SUM(H#{sum_start}:H#{sum_stop})"
    values.push(formula_value)
    values.push(formula_base_value)
    values.push(formula_vat_value)

    withholdings_names.each_with_index do |withh, index|
      formula = "=SUM(#{letter_range[index+8]}#{sum_start}:#{letter_range[index+8]}#{sum_stop})"
      values.push(formula)
    end
    return values
  end

  def sum_sources(source_names, years)
    letter_range = ("A".."Z").to_a + ("A".."Z").to_a.map { |letter| "A#{letter}"}
    values = ["(=)INGRESOS RECIBIDOS A LA FECHA"]
    source_names.each_with_index do |source, index|
      formula = "=SUM(#{letter_range[index+1]}3:#{letter_range[index+1]}#{years.length+2})"
      values.push(formula)
    end
    total_formula = "=SUM(#{letter_range[1]}#{years.length+3}:#{letter_range[source_names.length]}#{years.length+3})"
    values.push(total_formula)
    return values

  end

  def sum_annual_budgets(source_names, first, last)
    letter_range = ("A".."Z").to_a + ("A".."Z").to_a.map { |letter| "A#{letter}"}
    letter_range = letter_range[1..(source_names.length)]
    values = ["(=)TOTAL RECURSOS PRESUPUESTADOS POR GIRAR"] + formulas_report_component(letter_range, "SUM", first, last)
    total_formula = "=SUM(#{letter_range[0]}#{last + 1}:#{letter_range[-1]}#{last + 1})"
    values.push(total_formula)
    return values
  end

  def sum_returns(source_names, years)
    letter_range = ("A".."Z").to_a + ("A".."Z").to_a.map { |letter| "A#{letter}"}
    values = ["(=)RENDIMIENTOS FINANCIEROS CONSOLIDADOS"]
    source_names.each_with_index do |source, index|
      formula = "=SUM(#{letter_range[index+1]}#{years.length+4}:#{letter_range[index+1]}#{2*(years.length)+3})"
      values.push(formula)
    end
    total_formula = "=SUM(#{letter_range[1]}#{2*(years.length)+4}:#{letter_range[source_names.length]}#{2*(years.length)+4})"
    values.push(total_formula)
  end

  def total_incomes(source_names, years)
    letter_range = ("A".."Z").to_a + ("A".."Z").to_a.map { |letter| "A#{letter}"}
    values = ["(=)TOTALES INGRESOS CON RENDIMIENTOS FINANCIEROS "]
    source_names.each_with_index do |source, index|
      formula = "=#{letter_range[index+1]}#{years.length+3}+#{letter_range[index+1]}#{2*(years.length)+4}"
      values.push(formula)
    end
    total_formula = "=SUM(#{letter_range[1]}#{2*(years.length)+5}:#{letter_range[source_names.length]}#{2*(years.length)+5})"
    values.push(total_formula)
  end

  def sum_designates(source_names, years, last_row_index, type)
    letter_range = ("A".."Z").to_a + ("A".."Z").to_a.map { |letter| "A#{letter}"}
    type == 'add' ? values = ["(=)TOTAL RECURSOS COMPROMETIDOS TODAS LAS VIGENCIAS"] : values = ["(=)TOTAL RECURSOS LIBERADOS TODAS LAS VIGENCIAS"]
    source_names.each_with_index do |source, index|
      formula = "=SUM(#{letter_range[index+1]}#{last_row_index + 2}:#{letter_range[index+1]}#{last_row_index + years.length+1})"
      values.push(formula)
    end
    total_formula = "=SUM(#{letter_range[1]}#{last_row_index + years.length+2}:#{letter_range[source_names.length]}#{last_row_index + years.length+2})"
    values.push(total_formula)
    return values

  end

  def sum_rows(source_names, years, last_row_index, title)
    letter_range = ("A".."Z").to_a + ("A".."Z").to_a.map { |letter| "A#{letter}"}
    values = [title]
    source_names.each_with_index do |source, index|
      formula = "=SUM(#{letter_range[index+1]}#{last_row_index + 2}:#{letter_range[index+1]}#{last_row_index + years.length+1})"
      values.push(formula)
    end
    total_formula = "=SUM(#{letter_range[1]}#{last_row_index + years.length+2}:#{letter_range[source_names.length]}#{last_row_index + years.length+1})"
    values.push(total_formula)
    return values
  end


  def difference_rows(source_names, add_index, subtract_index, title)
    letter_range = ("A".."Z").to_a + ("A".."Z").to_a.map { |letter| "A#{letter}"}
    values = [title]
    source_names.each_with_index do |source, index|
    formula = "=#{letter_range[index+1]}#{add_index +2}-#{letter_range[index+1]}#{subtract_index + 1}"
    values.push(formula)
    end
    total_formula = "=SUM(#{letter_range[1]}#{subtract_index + 2}:#{letter_range[source_names.length]}#{subtract_index + 2})"
    values.push(total_formula)
    return values
  end

  def sources_row_values(year, index)
    letter_range = ("A".."Z").to_a + ("A".."Z").to_a.map { |letter| "A#{letter}"}
    last_value = "=SUM(#{letter_range[1]}#{index + 2}:#{letter_range[year.length-1]}#{index+2})"
    year.push(last_value)
    year
  end

  def returns_row_values(year, index, years)
    letter_range = ("A".."Z").to_a + ("A".."Z").to_a.map { |letter| "A#{letter}"}
    last_value = "=SUM(#{letter_range[1]}#{index+years.length+3}:#{letter_range[year.length-1]}#{index+years.length+3})"
    year.push(last_value)
    year
  end

  def funds_row_values(year, index, last_row_index)
    letter_range = ("A".."Z").to_a + ("A".."Z").to_a.map { |letter| "A#{letter}"}
    last_value = "=SUM(#{letter_range[1]}#{last_row_index + index+2}:#{letter_range[year.length-1]}#{last_row_index + index+2})"
    year.push(last_value)
    year
  end

  def source_annual_row_values(year, index, last_row_index)
    letter_range = ("A".."Z").to_a + ("A".."Z").to_a.map { |letter| "A#{letter}"}
    last_value = "=SUM(#{letter_range[1]}#{last_row_index + index+2}:#{letter_range[year.length-1]}#{last_row_index + index+2})"
    year.push(last_value)
    year
  end

  def designates_row_values(add_designate_year, index)
    letter_range = ("A".."Z").to_a + ("A".."Z").to_a.map { |letter| "A#{letter}"}
    last_value = "=SUM(#{letter_range[1]}#{index+2}:#{letter_range[add_designate_year.length-1]}#{index+2})"
    add_designate_year.push(last_value)
    add_designate_year
  end

  def add_months(c)
    validity = c.attributes['date_from'].to_date + 6.months
    return validity
  end

  def percentage_paid(c)
    paid = c.attributes['contract_pay'] / (c.initial_value * 100)
  end

  def title_row_merge(sources_names)
    letter_range = ("A".."Z").to_a + ("A".."Z").to_a.map { |letter| "A#{letter}"}
    limit_cell = 0
    limit_cell = sources_names.length * 3 + 4
    letter_merge = "#{letter_range[limit_cell]}"
    return letter_merge
  end

  def second_row_title(sources_names)
    labels = ['VALOR FUENTE CDR']
    x = sources_names.length+1
    space = ''
    x.times{labels.push(space)}
    labels.push('INFORMACION DEL CONTRATISTA','','','VALOR CONTRATADO POR FUENTE')
    x = sources_names.length-1
    x.times{labels.push(space)}
    labels.push('SALDO DISPONIBLE PARA CONTRATAR')
    x = sources_names.length-1
    x.times{labels.push(space)}

    return labels
  end

  def second_row_merge(sources_names)
    merge_list = []
    limit_cell = 0
    next_cell = 0
    letter_range = ("A".."Z").to_a + ("A".."Z").to_a.map { |letter| "A#{letter}"}
    limit_cell = sources_names.length + 1
    merge_list.push("A2:#{letter_range[limit_cell]}2")
    next_cell = limit_cell + 1
    limit_cell = next_cell + 2
    merge_list.push("#{letter_range[next_cell]}2:#{letter_range[limit_cell]}2")
    next_cell = limit_cell + 1
    limit_cell = next_cell + sources_names.length - 1
    merge_list.push("#{letter_range[next_cell]}2:#{letter_range[limit_cell]}2")
    next_cell = limit_cell + 1
    limit_cell = next_cell + sources_names.length - 1
    merge_list.push("#{letter_range[next_cell]}2:#{letter_range[limit_cell]}2")
    return merge_list
  end

  def names_columns(sources_names)
    labels = []
    sources_list = []
    labels.push('Nº CDR')
    sources_names.each do |source|
      sources_list.push(source.name.mb_chars.upcase)
    end
    labels.concat(sources_list)
    labels.push('VIGENCIA', 'NIT / # CEDULA', 'CONTRATISTA', 'N° CONTRATOS QUE AFECTA AL CDR')
    2.times { labels.concat(sources_list) }
    return labels
  end

  def balances_row_values(certificate, sources_names)

    query = <<-eos
    SELECT sources.name, designates.value, certificates.id
    FROM sources, designates, certificates WHERE designates.certificate_id = certificates.id AND sources.id = designates.source_id and certificates.number = '#{certificate.number}'
    eos

    source_by_cdr = Source.find_by_sql(query)
    list_names = []
    list_values = []
    source_name_list = []
    source_by_cdr.each do |i|
      list_names.push(i.name)
      list_values.push(i.value)
    end

    sources_names.each do |i|
      source_name_list.push(i.name)
    end

    values = [certificate.number]
    id_c = certificate.id.to_i

    source_name_list.each do |cell|
      query_value = <<-eos
      SELECT designates.value FROM designates, sources WHERE sources.id = designates.source_id and sources.name = '#{cell}' and designates.certificate_id = #{id_c}
      eos

      value_cell = Certificate.connection.select_all(query_value).rows
      values.push(value_cell == [] ? 0 : value_cell[0][0])
    end

    values.push("#{certificate.initial_date.strftime('%Y/%m/%d')} - #{certificate.limit_date.strftime('%Y/%m/%d')}")

    query_contractor = <<-eos
    SELECT string_agg(DISTINCT contractors.document_number, ' / '), string_agg(DISTINCT contractors.name, ', ') as name, string_agg( contracts.contract_number, ' - ')
    FROM budgets, contracts, contractors
    WHERE contracts.contractor_id = contractors.id AND contracts.id = budgets.contract_id and budgets.certificate_id = #{id_c}
    eos

    info_contractor = Budget.connection.select_all(query_contractor).rows
    info_contracts_contractor = []

    info_contractor.each do |subarray|
      subarray.each do |x|
        info_contracts_contractor.push(x)
      end
    end

    values.push("#{info_contracts_contractor[0]}")
    values.push("#{info_contracts_contractor[1]}")
    values.push("#{info_contracts_contractor[2]}")

    source_name_list.each do |cell|
      query_funds = <<-eos
      SELECT SUM(funds.value) AS Contratado
      FROM funds, budgets, contracts, designates, sources
      WHERE funds.budget_id = budgets.id AND
        funds.designate_id = designates.id AND designates.source_id = sources.id AND budgets.contract_id = contracts.id AND budgets.certificate_id = #{id_c} and sources.name= '#{cell}'
        eos

      info_funds = Fund.connection.select_all(query_funds).rows
      values.push(info_funds == [] || info_funds[0][0].nil? ? '0' : info_funds[0][0])
    end

    source_name_list.each do |cell|
      query_balance = <<-eos
      SELECT SUM(designates.value) - SUM(funds.value) as Saldo FROM funds, budgets, designates, sources WHERE funds.budget_id = budgets.id AND funds.designate_id = designates.id AND designates.source_id = sources.id AND budgets.certificate_id = #{id_c} AND sources.name= '#{cell}'
      eos

      info_balance = Designate.connection.select_all(query_balance).rows
      values.push(info_balance == [[]] || info_balance[0][0].nil? ? "0" : info_balance[0][0])
    end
    return values
  end

  def payment_data(item)
    values = []
    payment_cdrs = ''
    payment_sources = ''
    last_certificate = ''
    last_source = ''
    sum = 0
    item.payment.expenditures.each do |expenditure|
      if expenditure.value.positive?
        if expenditure.fund.budget.certificate.number.to_s != last_certificate
          payment_cdrs = payment_cdrs == '' ? expenditure.fund.budget.certificate.number.to_s : "#{payment_cdrs}, #{expenditure.fund.budget.certificate.number}"
        end
        last_certificate = expenditure.fund.budget.certificate.number.to_s
        if expenditure.fund.designate.source.name != last_source
          payment_sources = payment_sources == "" ?  expenditure.fund.designate.source.name : " - #{expenditure.fund.designate.source.name}"
        end
        last_source = expenditure.fund.designate.source.name
        sum += expenditure.fund.designate.value.to_i
      end
    end
    subtract = item.payment.value - (item.payment.prepayment_appliance || 0 )
    values = [payment_cdrs, payment_sources, sum, item.payment.contract.contractor.document_number.to_s, item.payment.contract.contractor.name, item.payment.contract.contract_number.to_s, " ", item.payment.observations, item.payment.value, item.payment.prepayment_appliance, subtract, item.payment.vat_value, (subtract) - item.payment.vat_value, subtract, item.payment.code, item.payment.date]
  end

  def fia_sheet_1
    components = Component.pluck(:id,:name)
    rows_sheet_1 = []
    @index_row_component = []
    @index_balace_available = []
    @index_row_sub_component = []
    row_component = []
    index_row = [[],[]]
    start_row = 4
    cnt_row_sheet_1 = 3
    index_component = 0

    components.each_with_index do |component, index|
      index_sub_component = []
      index_row_certificate = []
      sub_components = SubComponent.where(component_id: component[0]).pluck(:id, :name)
      number_component = index + 1
      start_row += 1
      cnt_row_sheet_1 += 1
      @index_row_component << cnt_row_sheet_1 - 4
      index_row[0] << cnt_row_sheet_1
      start_row_formula = start_row
      row_component = [number_component, component[1]] + ['-'] * 8 +["=SUM(C#{cnt_row_sheet_1}:J#{cnt_row_sheet_1})"]
      rows_sheet_1.push(row_component)

      sub_components.each_with_index do |sub_component, index|
        start_row += 1
        cnt_row_sheet_1 += 1
        index_sub_component << cnt_row_sheet_1
        @index_row_sub_component << cnt_row_sheet_1 - 4

        number_sub_component = "#{number_component}.#{index + 1}"
        row_sub_component = [number_sub_component, sub_component[1]] + ['-'] * 8
        rows_sheet_1.push(row_sub_component + ["=SUM(C#{cnt_row_sheet_1}:J#{cnt_row_sheet_1})"])
        cnt_row_sheet_1 += 1
        index_row[1] << cnt_row_sheet_1
        index_row_certificate << cnt_row_sheet_1

        row_total_certificate = [number_sub_component, "Recursos Comprometidos", total_sub_component_by_sources(@name_sources,    sub_component[0])].flatten

        rows_sheet_1.push(row_total_certificate + ["=SUM(C#{cnt_row_sheet_1}:J#{cnt_row_sheet_1})"])
        cnt_row_sheet_1 += 1
        @index_balace_available << cnt_row_sheet_1 - 4

        balance_available = [number_sub_component, "Saldo Aprobado disponible por ejecutar"]
        ('C'..'J').to_a.each do |letter|
          balance_available << "=#{letter}#{start_row_formula}-#{letter}#{start_row}"
        end

        balance_available << "=SUM(C#{cnt_row_sheet_1}:J#{cnt_row_sheet_1})"
        rows_sheet_1.push(balance_available)

        start_row += 2
        start_row_formula = start_row
      end

      index_component = @index_row_component[index]
      row_component = row_component[0..1] + formula_total_sum('C'..'J', index_sub_component) + [row_component[10], '']
      rows_sheet_1[index_component] = row_component
    end

    row_total_paei = ['',"Costo Total Componentes PAEI"] + formula_total_sum('C'..'J', index_row[0]) + ["=SUM(C#{cnt_row_sheet_1 + 1}:J#{cnt_row_sheet_1 + 1})"]

    row_total_pgei = ['',"Costo Total Componentes PGEI"] + formula_total_sum('C'..'J', index_row[1]) + ["=SUM(C#{cnt_row_sheet_1 + 2}:J#{cnt_row_sheet_1 + 2})"]

    rows_sheet_1.push(row_total_paei)
    rows_sheet_1.push(row_total_pgei)
  end

  def fia_sheet_2
    components = Component.pluck(:id,:name)
    rows_sheet_2 = []
    @index_row_component = []
    @index_balace_available = []
    @index_row_sub_component = []
    @index_row_executed = []
    @row_merge = []
    row_component = []
    index_row = [[],[]]
    start_row = 4
    cnt_row_sheet_2 = 3
    index_component = 0

    components.each_with_index do |component, index|
      index_sub_component = []
      index_resources_certificates = []
      index_row_certificate = []
      sub_components = SubComponent.where(component_id: component[0]).pluck(:id, :name)
      number_component = index + 1
      start_row += 1
      cnt_row_sheet_2 += 1
      @index_row_component << cnt_row_sheet_2 - 4
      index_row[0] << cnt_row_sheet_2
      start_row_formula = start_row
      row_component = [number_component, component[1]] + ['-'] * 8 +["=SUM(C#{cnt_row_sheet_2}:J#{cnt_row_sheet_2})",'']
      rows_sheet_2.push(row_component)

      sub_components.each_with_index do |sub_component, index|
        start_row += 1
        cnt_row_sheet_2 += 1
        index_sub_component << cnt_row_sheet_2
        @index_row_sub_component << cnt_row_sheet_2 - 4

        number_sub_component = "#{number_component}.#{index + 1}"
        row_sub_component = [number_sub_component, sub_component[1]] + ['-'] * 8 + ["=SUM(C#{cnt_row_sheet_2}:J#{cnt_row_sheet_2})","=K#{cnt_row_sheet_2 + 1}/K#{cnt_row_sheet_2}"]

        rows_sheet_2.push(row_sub_component)
        cnt_row_sheet_2 += 1
        index_row[1] << cnt_row_sheet_2
        index_row_certificate << cnt_row_sheet_2
        index_resources_certificates << cnt_row_sheet_2

        row_total_certificate = [number_sub_component, "Recursos Comprometidos", total_sub_component_by_sources(@name_sources,    sub_component[0])].flatten

        rows_sheet_2.push(row_total_certificate + ["=SUM(C#{cnt_row_sheet_2}:J#{cnt_row_sheet_2})", ''])
        cnt_row_sheet_2 += 1
        @index_balace_available << cnt_row_sheet_2 - 4

        balance_available = [number_sub_component, "Saldo Aprobado disponible por ejecutar"]
        ('C'..'J').to_a.each do |letter|
          balance_available << "=#{letter}#{start_row_formula}-#{letter}#{start_row}"
        end

        balance_available << "=SUM(C#{cnt_row_sheet_2}:J#{cnt_row_sheet_2})"
        rows_sheet_2.push(balance_available + [''])

        start_row += 2
        start_row_formula = start_row
      end

      start_row += 2
      index_component = @index_row_component[index]
      row_component = row_component[0..1] + formula_total_sum('C'..'J', index_sub_component) + [row_component[10], '']
      rows_sheet_2[index_component] = row_component
      cnt_row_sheet_2 += 1

      total_executed = [number_component, 'TOTAL EJECUTADO POR COMPONENTE'] + formula_total_sum('C'..'K', index_row_certificate)
      total_percentage_excecuted = ['', 'TOTAL PORCENTAJE DE EJECUCIÓN POR COMPONENTE']
      ('C'..'K').to_a.each do |letter|
        total_percentage_excecuted << "=#{letter}#{cnt_row_sheet_2}/#{letter}#{index_component + 4}"
      end

      rows_sheet_2.push(total_executed + [''])
      rows_sheet_2.push(total_percentage_excecuted + [''])
      cnt_row_sheet_2 += 1
      @index_row_executed << cnt_row_sheet_2 - 5
      @index_row_executed << cnt_row_sheet_2 - 4
      @row_merge << [cnt_row_sheet_2 - 1, cnt_row_sheet_2]
    end

    row_total_paei = ['',"Costo Total Componentes PAEI"] + formula_total_sum('C'..'J', index_row[0]) + ["=SUM(C#{cnt_row_sheet_2 + 1}:J#{cnt_row_sheet_2 + 1})", '']

    row_total_pgei = ['',"Costo Total Componentes PGEI"] + formula_total_sum('C'..'J', index_row[1]) + ["=SUM(C#{cnt_row_sheet_2 + 2}:J#{cnt_row_sheet_2 + 2})", '']

    rows_sheet_2.push(row_total_paei)
    rows_sheet_2.push(row_total_pgei)
  end

  def fia_sheet_3
    components = Component.pluck(:id,:name)
    rows_sheet_3 = []
    @index_row_component = []
    @index_balace_available = []
    @index_row_sub_component = []
    @index_row_executed = []
    @row_merge = []
    row_component = []
    index_row = [[],[]]
    start_row = 4
    cnt_row_sheet_3 = 3
    index_component = 0
    row_total_certificate = []

    components.each_with_index do |component, index|
      row_projects = []
      index_sub_component = []
      index_resources_certificates = []
      index_row_certificate = []
      sub_components = SubComponent.where(component_id: component[0]).pluck(:id, :name)
      number_component = index + 1
      start_row += 1
      cnt_row_sheet_3 += 1
      @index_row_component << cnt_row_sheet_3 - 4
      index_row[0] << cnt_row_sheet_3
      start_row_formula = start_row
      row_component = [number_component, component[1]] + ['-'] * 8 +["=SUM(C#{cnt_row_sheet_3}:J#{cnt_row_sheet_3})",'']
      rows_sheet_3.push(row_component)

      sub_components.each_with_index do |sub_component, index|
        index_projects = []
        start_row += 1
        cnt_row_sheet_3 += 1
        index_sub_component << cnt_row_sheet_3
        @index_row_sub_component << cnt_row_sheet_3 - 4

        number_sub_component = "#{number_component}.#{index + 1}"
        row_sub_component = [number_sub_component, sub_component[1]] + ['-'] * 8 + ["=SUM(C#{cnt_row_sheet_3}:J#{cnt_row_sheet_3})", cnt_row_sheet_3]
        rows_sheet_3.push(row_sub_component)
        row_sub_component = rows_sheet_3[-1]

        row_total_certificate = array_certificate_with_value_for_sources(@name_sources, sub_component[0])
        row_total_certificate.each do |row|
          cnt_row_sheet_3 += 1
          index_projects << cnt_row_sheet_3
          rows_sheet_3.push(row + ["=SUM(C#{cnt_row_sheet_3}:J#{cnt_row_sheet_3})", ''])
        end

        row_projects << index_projects
        index_row_sub_component = row_sub_component[-1]
        formula_total = formula_total_sum('K'..'K', row_projects[index]).join
        row_sub_component[-1] = formula_total.length > 1 ? "=(#{formula_total.delete_prefix("=")})/K#{index_row_sub_component}" : ""

        cnt_row_sheet_3 += 1
        @index_balace_available << cnt_row_sheet_3 - 4

        balance_available = [number_sub_component, "Saldo Aprobado disponible por ejecutar"] + @available_for_execute + ["=SUM(C#{cnt_row_sheet_3}:J#{cnt_row_sheet_3})"]
        rows_sheet_3.push(balance_available + [''])

        start_row += 2
        start_row_formula = start_row
      end

      start_row += 2 + row_total_certificate.length
      index_component = @index_row_component[index]
      row_component = row_component[0..1] + formula_total_sum('C'..'J', index_sub_component) + [row_component[10], '']
      rows_sheet_3[index_component] = row_component
      cnt_row_sheet_3 += 1

      total_executed = [number_component, 'TOTAL EJECUTADO POR COMPONENTE'] + formula_total_sum('C'..'J', row_projects.flatten) + ["=SUM(C#{cnt_row_sheet_3}:J#{cnt_row_sheet_3})"]
      total_percentage_excecuted = ['', 'TOTAL PORCENTAJE DE EJECUCIÓN POR COMPONENTE']
      ('C'..'K').to_a.each do |letter|
        total_percentage_excecuted << "=#{letter}#{cnt_row_sheet_3}/#{letter}#{index_component + 4}"
      end

      rows_sheet_3.push(total_executed + [''])
      rows_sheet_3.push(total_percentage_excecuted + [''])
      index_row[1] << cnt_row_sheet_3
      cnt_row_sheet_3 += 1
      @index_row_executed << cnt_row_sheet_3 - 5
      @index_row_executed << cnt_row_sheet_3 - 4
      @row_merge << [cnt_row_sheet_3 - 1, cnt_row_sheet_3]
    end

    row_total_paei = ['',"Costo Total Componentes PAEI"] + formula_total_sum('C'..'J', index_row[0]) + ["=SUM(C#{cnt_row_sheet_3 + 1}:J#{cnt_row_sheet_3 + 1})", '']

    row_total_pgei = ['',"Costo Total Componentes PGEI"] + formula_total_sum('C'..'J', index_row[1]) + ["=SUM(C#{cnt_row_sheet_3 + 2}:J#{cnt_row_sheet_3 + 2})", '']

    rows_sheet_3.push(row_total_paei)
    rows_sheet_3.push(row_total_pgei)
  end

  def array_certificate_with_value_for_sources(sources, sub_component_id)
    certificates = @certificates.where(sub_component_id: sub_component_id)
    @available_for_execute = [0] * 8
    available_for_execute = 0
    rows = []
    certificates.each do |certificate|
      row_projects = ['', certificate.project_name]
      sources.each_with_index do |code, index|
        sources_id = Source.where('name LIKE ?', "%#{code}%").pluck(:id)
        designates = Designate.where(source_id: sources_id, certificate_id: certificate)

        total_certificate = designates.sum(:value)
        available_for_execute = total_certificate - Fund.where(budget_id: Budget.where(certificate_id: certificate), designate_id: designates.pluck(:id)).sum(:value)
        @available_for_execute[index] += available_for_execute
        row_projects << total_certificate
      end
      rows.push(row_projects)
    end
    rows
  end

  def report_for_municipios(municipio)
    certificates = @certificates.where('lower(project_name) LIKE lower(?)',"%#{municipio[0]}%")

    municipio.each_with_index do |name, index|
      certificates = certificates.or(@certificates.where('lower(project_name) LIKE lower(?)',"%#{municipio[index + 1]}%")) if index + 1 < municipio.length
    end

    cnt_cells = 2
    values_rows = []

    certificates.each do |certificate|
      budgets = certificate.budgets
      value_contract = Fund.where(budget_id: budgets.pluck(:id)).sum(:value)
      values_rows << [certificate.number, certificate.project_name, value_contract]
    end

    cnt_cells = 2 + (certificates.length == 0 ? 1 : certificates.length)

    values_rows << ["TOTAL INVERSIÓN",'',formulas_report_component('C'..'C', "SUM", 3, cnt_cells)[0]]
    contributions_by_municipality(certificates, municipio[0], cnt_cells)
    values_rows
  end

  def contributions_by_municipality(certificates, municipio, start_cell)
    date_from = Date.parse(@start_date)
    date_to = Date.parse(@end_date)
    date_range = date_from..date_to
    date_years = date_range.map { |d| Date.new(d.year) }.uniq
    certificate_id = certificates.pluck(:id)
    designates = Designate.where(certificate_id: certificate_id)
    sources_id = designates.pluck(:source_id)
    @years = date_years.map { |d| d.strftime "%Y" }
    @value_contributions_table = []
    @value_financial_table = []
    start_row = start_cell + (certificates.length == 0 ? 0 : 1)
    start_cell += 4 + (certificates.length == 0 ? 0 : 1)
    end_cell = start_cell

    @years.each do |year|
      if year == year.last
        date_end = @end_date.end_of_day
      else
        date_end = Date.parse("#{year}/12/31").end_of_day
      end

      year_value_source = Income.where(source_id: sources_id).where(["income_date BETWEEN :begin AND :end AND NOT financial_return", {begin: "#{year}/01/01", end: date_end}]).sum(:income_value)

      @value_contributions_table.push(['', "INGRESOS RECIBIDOS DE LA VIGENCIA #{year}", year_value_source])
    end

    value_returns = Income.where(source_id: sources_id).where(["income_date BETWEEN :begin AND :end AND financial_return", {begin: @start_date, end: @end_date}]).sum(:income_value)

    value_certificate = designates.sum(:value)
    start_cell += 1
    end_cell += @years.length

    @value_contributions_table.push(['', "TOTAL APORTES", "=SUM(C#{start_cell}:C#{end_cell})"])
    start_cell = end_cell + 1
    end_cell = start_cell + 1

    @value_contributions_table.push(['', "RENDIMIENTOS FINANCIEROS GENERADOS", value_returns])
    @value_contributions_table.push(['', "TOTAL RECURSOS", "=SUM(C#{start_cell}:C#{end_cell})"])
    @value_contributions_table.push(['', "COMPROMETIDO POR MUNICIPIO", value_certificate])
    start_cell = end_cell + 1
    end_cell = start_cell + 1
    @data = end_cell + 8
    @value_contributions_table.push(['', "SALDO DISPONIBLE PARA INVERSIÓN", "=C#{start_cell}-C#{end_cell}"])

    @value_financial_table.push(['', "TOTAL INVERSIÓN PARA EL MUNICIPIO DE #{municipio.upcase}", "=C#{start_row}"])
    @value_financial_table.push(['', 'TOTAL APORTES PDA DEPARTAMENTO', "=C#{start_row}-C#{end_cell}"])
    @value_financial_table.push(['', "TOTAL APORTES MUNICIPIO  MUNICIPIO DE #{} (#{@years[0]} AL #{@years[-1]})","=C#{end_cell}"])
  end

  def financial_sheet_2
    sources = Source.where('name LIKE ?','%MUNICIPIO%')
    array_values_municipios = []
    end_date = Date.parse(@end_date).end_of_day

    sources.each do |source|
      year_value_source = source.incomes.where(["income_date BETWEEN :begin AND :end AND NOT financial_return", {begin: @start_date, end: end_date}]).sum(:income_value)
      year_value_returns = source.incomes.where(["income_date BETWEEN :begin AND :end AND financial_return", {begin: @start_date, end: end_date}]).sum(:income_value)
      year_value_add_designate = Transaction.joins("INNER JOIN designates ON transactionable_id = designates.id ").where(["transactions.issue_date > :begin AND transactions.issue_date < :end AND transaction_type = 'add' AND transactionable_type = 'Designate' AND designates.source_id = :source", {begin: @start_date, end: end_date, source: source.id}]).sum(:amount)
      year_value_add_designate -= Transaction.joins("INNER JOIN designates ON transactionable_id = designates.id ").where(["transactions.issue_date > :begin AND transactions.issue_date < :end AND transaction_type = 'subtract' AND transactionable_type = 'Designate' AND designates.source_id = :source", {begin: @start_date, end: end_date, source: source.id}]).sum(:amount)
      name = source.name.delete_prefix("RECURSOS MUNICIPIO DEL")
      name = name.delete_prefix("RECURSOS MUNICIPIO DE")

      array_values_municipios << [name.delete_prefix("RECURSOS MUNICIPIO"), year_value_source, year_value_returns, year_value_add_designate, source.available_value]
    end
    array_values_municipios
  end

  def financial_report()

    sources = Source.all
    date_from = Date.parse(@start_date)
    date_to = Date.parse(@end_date)
    date_range = date_from..date_to
    date_years = date_range.map { |d| Date.new(d.year) }.uniq
    @years = date_years.map { |d| d.strftime "%Y" }
    @income_years = {sheet_1: [], sheet_2: []}
    @incomes_return_year = {sheet_1: [], sheet_2: []}
    @add_designate_years = {sheet_1: [], sheet_2: []}
    @subtract_designate_years = {sheet_1: [], sheet_2: []}
    @fund_years = {sheet_1: [], sheet_2: []}
    @source_annual_budgets = {sheet_1: [], sheet_2: []}
    @sources_names = { sheet_1: [], sheet_2: []}
    @sources_names[:sheet_1] = Source.where('name NOT LIKE ?','%MUNICIPIO%').pluck(:name) << "SGP MUNICIPIO"
    @sources_names[:sheet_2] = Source.where('name LIKE ?','%MUNICIPIO%').pluck(:name)
    #@incomes_return_last_year = ["(+)Rendimientos Financieros A 31de Diciembre- #{@years[-2]}"]
    #@incomes_return_ending_date = ["(+)Rendimientos Financieros vigencia - A #{end_date}"]

    @years.each do |year|

      income_year_value = 0
      income_year = {sources: [], sources_municipaly: []}
      return_year = {sources: [], sources_municipaly: []}
      add_designate_year = {sources: [], sources_municipaly: []}
      subtract_designate_year = {sources: [], sources_municipaly: []}
      fund_year = {sources: [], sources_municipaly: []}
      source_annual_budget = {sources: [], sources_municipaly: []}

      income_year[:sources].push("(+)Ingresos año #{year}")
      return_year[:sources].push("(+)Rendimientos Financieros año #{year}")
      add_designate_year[:sources].push("Certificados año #{year}")
      subtract_designate_year[:sources].push("(-)Liberaciones año #{year}")
      fund_year[:sources].push("Ejecutados año #{year}")
      source_annual_budget[:sources].push("RECURSOS PENDIENTES POR GIRAR AL FIA VIGENCIA #{year}")

      income_year[:sources_municipaly].push("(+)Ingresos año #{year}")
      return_year[:sources_municipaly].push("(+)Rendimientos Financieros año #{year}")
      add_designate_year[:sources_municipaly].push("Certificados año #{year}")
      subtract_designate_year[:sources_municipaly].push("(-)Liberaciones año #{year}")
      fund_year[:sources_municipaly].push("Ejecutados año #{year}")
      source_annual_budget[:sources_municipaly].push("RECURSOS PENDIENTES POR GIRAR AL FIA VIGENCIA #{year}")

      sources.each do |source|
        if year == @years.last
          date_end = date_to.end_of_day
        else
          date_end = Date.parse("#{year}/12/31").end_of_day
        end
        year_value_source = source.incomes.where(["income_date BETWEEN :begin AND :end AND NOT financial_return", {begin: "#{year}/01/01", end: date_end}]).sum(:income_value)
        year_value_returns = source.incomes.where(["income_date BETWEEN :begin AND :end AND financial_return", {begin: "#{year}/01/01", end: date_end}]).sum(:income_value)
        year_value_add_designate = Transaction.joins("INNER JOIN designates ON transactionable_id = designates.id ").where(["transactions.issue_date > :begin AND transactions.issue_date < :end AND transaction_type = 'add' AND transactionable_type = 'Designate' AND designates.source_id = :source", {begin: "#{year}/01/01", end: date_end, source: source.id}]).sum(:amount)
        year_value_subtract_designate = Transaction.joins("INNER JOIN designates ON transactionable_id = designates.id ").where(["transactions.issue_date > :begin AND transactions.issue_date < :end AND transaction_type = 'subtract' AND transactionable_type = 'Designate' AND designates.source_id = :source", {begin: "#{year}/01/01", end: date_end, source: source.id}]).sum(:amount)
        #year_value_subtract_fund = Transaction.joins("INNER JOIN funds ON transactionable_id = funds.id JOIN designates ON designates.id = funds.designate_id ").where(["transactions.issue_date > :begin AND transactions.issue_date < :end AND transaction_type = 'subtract' AND transactionable_type = 'Fund' AND designates.source_id = :source", {begin: "#{year}/01/01", end: date_end, source: source.id}]).sum(:amount)
        #year_value_add_fund = Transaction.joins("INNER JOIN funds ON transactionable_id = funds.id JOIN designates ON designates.id = funds.designate_id ").where(["transactions.issue_date > :begin AND transactions.issue_date < :end AND transaction_type = 'add' AND transactionable_type = 'Fund' AND designates.source_id = :source", {begin: "#{year}/01/01", end: date_end, source: source.id}]).sum(:amount)
        year_value_add_fund = Expenditure.joins("INNER JOIN payments ON payment_id = payments.id JOIN funds ON fund_id = funds.id JOIN designates ON designates.id = funds.designate_id").where(["payments.date > :begin AND payments.date < :end AND designates.source_id = :source", {begin: "#{year}/01/01", end: date_end, source: source.id}]).sum(:value)

        annual_budgets_id = AnnualBudget.where(paei_year: year).pluck(:id)
        year_value_annual_budget = SourceAnnualBudget.where(source_id: source.id, annual_budget_id: annual_budgets_id).sum(:compromised_amount)

        unless source.name.include?("MUNICIPIO")
          income_year[:sources].push(year_value_source)
          return_year[:sources].push(year_value_returns)
          add_designate_year[:sources].push(year_value_add_designate)
          subtract_designate_year[:sources].push(year_value_subtract_designate)
          fund_year[:sources].push(year_value_add_fund)
          source_annual_budget[:sources].push(year_value_annual_budget)
        else
          income_year[:sources_municipaly].push(year_value_source)
          return_year[:sources_municipaly].push(year_value_returns)
          add_designate_year[:sources_municipaly].push(year_value_add_designate)
          subtract_designate_year[:sources_municipaly].push(year_value_subtract_designate)
          fund_year[:sources_municipaly].push(year_value_add_fund)
          source_annual_budget[:sources_municipaly].push(year_value_annual_budget)
        end
      end

      income_year[:sources].push(income_year[:sources_municipaly][1..-1].inject(0, :+))
      return_year[:sources].push(return_year[:sources_municipaly][1..-1].inject(0, :+))
      add_designate_year[:sources].push(add_designate_year[:sources_municipaly][1..-1].inject(0, :+))
      subtract_designate_year[:sources].push(subtract_designate_year[:sources_municipaly][1..-1].inject(0, :+))
      fund_year[:sources].push(fund_year[:sources_municipaly][1..-1].inject(0, :+))
      source_annual_budget[:sources].push(source_annual_budget[:sources_municipaly][1..-1].inject(0, :+))

      @income_years[:sheet_1].push(income_year[:sources])
      @incomes_return_year[:sheet_1].push(return_year[:sources])
      @add_designate_years[:sheet_1].push(add_designate_year[:sources])
      @subtract_designate_years[:sheet_1].push(subtract_designate_year[:sources])
      @fund_years[:sheet_1].push(fund_year[:sources])
      @source_annual_budgets[:sheet_1].push(source_annual_budget[:sources])

      @income_years[:sheet_2].push(income_year[:sources_municipaly])
      @incomes_return_year[:sheet_2].push(return_year[:sources_municipaly])
      @add_designate_years[:sheet_2].push(add_designate_year[:sources_municipaly])
      @subtract_designate_years[:sheet_2].push(subtract_designate_year[:sources_municipaly])
      @fund_years[:sheet_2].push(fund_year[:sources_municipaly])
      @source_annual_budgets[:sheet_2].push(source_annual_budget[:sources_municipaly])
    end
  end

  def col_widths(sources_names)
    col_widths = []
    col_widths.push(nil)
    sources_names.each do |source|
      if source.length >= 49
        col_widths.push(source.length + 11)
      else
        col_widths.push(source.length + 6)
      end
    end
    col_widths.push(22)
  end
end
