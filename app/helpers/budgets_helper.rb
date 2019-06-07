module BudgetsHelper
  def certificate_concatanated_hash
    certificate_concatanated = {}
    not_available_certificate = Budget.where(contract_id: @contract.id).pluck(:certificate_id)
    Certificate.where.not(id: not_available_certificate).each do |certificate|
      certificate_concatanated[certificate.id] = "#{certificate.number} - #{certificate.project_name}"
    end
    certificate_concatanated.sort_by {|key, certificate| certificate}
  end

  def total_budgets_value(budgets)
    total = 0
    budgets.each do |b|
      total += b.total_value
    end
    total
  end

  def total_budgets_addition_value(budgets)
    total = 0
    budgets.each do |b|
      total += b.total_additions_value
    end
    total
  end

  def total_budgets_contract_value(budgets)
    total = 0
    budgets.each do |b|
      total += b.total_value - b.total_additions_value 
    end
    total
  end

  def fetch_transactions(budget)
    transactions = []
    budget.funds.each do |fund|
      fund.transactions.each do |transaction|
        transactions << transaction
      end
    end
    transactions
  end
end
