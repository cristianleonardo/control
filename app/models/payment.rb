# coding: utf-8
class Payment < ApplicationRecord
  belongs_to :contract
  belongs_to :subcontract
  before_save :calculate_base_and_vat

  def self.searchable_columns
    [:code]
  end

  def self.searchable_language
    'spanish'
  end

  def calculate_base_and_vat
    if vat
      self.base_value = value / (1 + (vat_percentage / 100))
      self.vat_value = value - self.base_value
    else
      self.base_value = value
      self.vat_value = 0
    end
  end

  def self.payments_search(search_params)
    params = {}.merge(search_params)
    unless (search_params["st_date"].blank? && search_params["ed_date"].blank?)
      st_date = search_params["st_date"].blank? ? Payment.all.order(:date).first.date : Date.parse(search_params["st_date"])
      ed_date = search_params["ed_date"].blank? ? Date.today : Date.parse(search_params["ed_date"])
      params.merge!({date: st_date..ed_date})
    end
    code = params["code"] if params["code"]
    params.merge!(contracts: {contractor_id: params["contractor"]}) if params["contractor"]
    params.except!("st_date", "ed_date", "contractor", "code")
    if code
      res = Payment.basic_search(code: code).where(params).includes(:contract)
      res = res.empty? ? Payment.joins(:contract).advanced_search(contracts: {contract_number: code}) : res
    else
      Payment.where(params).includes(:contract)
    end

  end

  def calculate_original_value(value, total_value)
    fraction =  value / total_value
    self.value * fraction
  end

  def calculate_contract_available_value
    contract.available_value + value_was
  end

  # Begin cached methods

  # def cached_expenditures
  #   Rails.cache.fetch([self, "expenditures"]) { expenditures }
  # end
  #
  # def cached_withholdings
  #   Rails.cache.fetch([self, "withholdings"]) { withholdings.to_a }
  # end
  #
  # def cached_withholdings_where(abbreviation, percentage)
  #   Rails.cache.fetch([self, "#{id}withholdings_where#{abbreviation}#{percentage}"]) { withholdings.where(abbreviation: abbreviation, percentage: percentage) }
  # end
  #
  # def cached_flush
  #   Rails.cache.delete([self, "withholdings"])
  #   Rails.cache.delete([self, "expenditures"])
  # end
end
