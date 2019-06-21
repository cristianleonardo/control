module StrategicPlanningHelper
  def show_all(sources,sub_components, params)
    @total_contract = []
    @total_payment = []
    @total_certificate = []
    @total_available = []

    certificates_id = @certificates.where(sub_component_id: sub_components).pluck(:id)

    sources.each do |code|
      sources_id = Rails.cache.fetch("strategic_source_#{sub_components}_#{code}/#{params}") { Source.where('name LIKE ?', "%#{code}%").pluck(:id) }
      designates = Rails.cache.fetch("strategic_designate_#{sub_components}_#{code}/#{params}") { Designate.where(source_id: sources_id, certificate_id: certificates_id) }
      budgets = Rails.cache.fetch("strategic_source_budget_#{sub_components}_#{code}/#{params}") { Budget.where(certificate_id: designates.pluck(:certificate_id)) }
      payments = Rails.cache.fetch("strategic_source_payment_#{sub_components}_#{code}/#{params}") { @payments.where(contract_id: budgets.pluck(:contract_id)) }
      fund_designates = Rails.cache.fetch("strategic_source_fund_#{sub_components}_#{code}/#{params}") { Fund.where(designate_id: designates.pluck(:id)) }
      expenditures = Rails.cache.fetch("strategic_source_expenditure_#{sub_components}_#{code}/#{params}") { Expenditure.where(payment_id: payments.pluck(:id), fund_id: fund_designates.pluck(:id)) }

      total_contract = fund_designates.sum(:value)
      total_certificate = designates.sum(:value)
      total_payment = expenditures.sum(:value)
      total_available = total_certificate - Fund.where(budget_id: budgets.pluck(:id), designate_id: designates.pluck(:id)).sum(:value)

      @total_contract.push(total_contract)
      @total_payment.push(total_payment)
      @total_certificate.push(total_certificate)
      @total_available.push(total_available)
    end
  end

  def truncate_components
    components = []
    @components.each do |comp|
      components.push(comp.truncate(25, separator: /\s/))
    end
    components
  end

  def arr_sub_components(component)
    @sub_components_id = SubComponent.where(component_id: component).pluck(:id)
    @sub_components = SubComponent.where(component_id: component).pluck(:name)
  end
end
