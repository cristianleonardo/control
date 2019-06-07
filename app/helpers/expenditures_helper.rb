module ExpendituresHelper
  def fund_available(expenditure_id)
    @expenditure = Expenditure.find(expenditure_id)
  end
  def expenditure_fund(expenditure)
    @fund = Expenditure.find(expenditure.id).fund
  end
end
