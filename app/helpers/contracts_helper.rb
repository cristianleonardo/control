module ContractsHelper
  def total_additions_value(contract)
    contract.total_value
  end

  def contracts_report
    contracts_data = []
    key_hash = [:process_number, :contractual_object, :observations]
    hash_dates = [:suscription_date, :start_date, :settlement_date, :opening_date, :ending_date, :award_date]
    modes = CONTRACT_MODE.invert.as_json
    states = CONTRACT_STATES.invert.as_json

    @contracts.each do |contract|
      data = []

      key_hash.each do |key|
        data.push(contract[key])
      end

      hash_dates.each do |key|
        data.push(contract[key] ? contract[key].strftime("%Y-%m-%d") : '')
      end

      contract_mode = modes[contract[:mode]]
      contract_state = states[contract[:state]]
      contract_type = ContractType.find(contract[:contract_type_id])
      city = City.find(contract[:city_id])
      interventor = get_contractor_name(contract[:interventor_contractor_id])
      supervisor = get_contractor_name(contract[:supervisor_contractor_id])
      contractor = get_contractor_name(contract[:contractor_id])

      data.push(contract_mode)
      data.push(contract_state)
      data.push(contract_type.name)
      data.push(city.name)
      data.push(interventor)
      data.push(supervisor)
      data.push(contractor)
      data.push(term_contract(contract))
      data.push(contract[:initial_value])
      data.push(contract.fetch_value)
      data.push(contract.total_value)

      contracts_data.push(data)
    end
    contracts_data
  end

  def term_contract(contract)
    term_months = "#{contract[:term_months]}M" if contract[:term_months] > 0
    term_days = "#{contract[:term_days]}D" if contract[:term_days] > 0
    return !term_days.blank? ? "#{term_months} Y #{term_days}" : term_months
  end

  def get_contractor_name(contractor_id)
    contractor = Contractor.find_by_id(contractor_id)
    !contractor.blank? ? contractor.name : '-'
  end
end
