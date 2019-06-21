class Contract < ApplicationRecord
  has_many :payments
  has_many :medias, dependent: :destroy
  belongs_to :contractor, :class_name => 'Contractor', :foreign_key => 'contractor_id'
  belongs_to :interventor, :class_name => 'Contractor', :foreign_key => 'interventor_contractor_id', optional: true
  belongs_to :supervisor, :class_name => 'Contractor', :foreign_key => 'supervisor_contractor_id', optional: true
  belongs_to :contract_type
  validate   :validate_contractor_supervisor_interventor
  validates  :contract_type_id, presence: true
  after_commit :cached_flush

  def self.searchable_columns
    [:process_number, :contract_number]
  end

  def self.searchable_language
    'spanish'
  end

  def self.contracts_search(search_params)
    params = {}.merge(search_params)
    unless (search_params["st_date"].blank? && search_params["ed_date"].blank?)
      st_date = search_params["st_date"].blank? ? Contract.all.order(:opening_date).first.opening_date : Date.parse(search_params["st_date"])
      ed_date = search_params["ed_date"].blank? ? Date.today : Date.parse(search_params["ed_date"])
      params.merge!({opening_date: st_date..ed_date})
    end
    keyword = params["keyword"]
    certificate_id = params["certificate_id"]
    source_id = params["source_id"]
    params.except!("keyword", "st_date", "ed_date", "certificate_id", "opening_date", "source_id")
    if certificate_id
      params.merge!(budgets:{certificate_id: certificate_id})
      q = 'join budgets on budgets.contract_id = contracts.id'
    end
    if source_id
      params.merge!(budgets:{certificate:{designates:{source_id: source_id}}})
      q = 'join budgets on budgets.contract_id = contracts.id join certificates on budgets.certificate_id = certificates.id join designates on designates.certificate_id = certificates.id'
    end
    unless keyword.blank?
      Contract.advanced_search(keyword).joins("#{q}").where(params)
    else
      Contract.joins("#{q}").where(params)
    end
  end

  def validate_contractor_supervisor_interventor
      if supervisor_contractor_id != nil && (contractor_id == supervisor_contractor_id)
        errors.add(:contractors, ' El contratista no puede ser el mismo supervisor')
      elsif interventor_contractor_id != nil && (contractor_id == interventor_contractor_id)
        errors.add(:contractors, ' El contratista no puede ser el mismo interventor')
      elsif (supervisor_contractor_id != nil && interventor_contractor_id != nil) && (supervisor_contractor_id == interventor_contractor_id)
        errors.add(:contractors, ' El supervisor no puede ser el mismo interventor')
      end
  end

  # Begin cached methods

  def self.cached_all
    Rails.cache.fetch('Contract.all') { all.to_a }
  end

  def cached_payments
    Rails.cache.fetch([self, "payments"]) { payments }
  end

  def cached_medias
    Rails.cache.fetch([self, "medias"]) { medias }
  end

  def cached_flush
    Rails.cache.delete([self,"payments"])
    Rails.cache.delete([self,"medias"])
    Rails.cache.delete('Contract.all')
  end
end
