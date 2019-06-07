module FundsHelper
  def designate_available(fund_id)
    @fund = Fund.find(fund_id)
    @fund.designate_available_value
  end
end
