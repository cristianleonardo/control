class Contractor < ApplicationRecord
  has_many :supervisions, :class_name => 'Contracts', :foreign_key => 'supervisor_contractor_id'
  has_many :interventions, :class_name => 'Contracts', :foreign_key => 'interventor_contractor_id'
  has_many :contracts
  has_many :subcontracts
  belongs_to :contractor_type
  has_many :payments
  after_commit :cached_flush

  def self.searchable_columns
    [:name, :document_number]
  end

  def self.searchable_language
    'spanish'
  end

  def cached_supervisions
    Rails.cache.fetch([self, "supervisions"]) { supervisions }
  end

  def cached_interventions
    Rails.cache.fetch([self, "interventions"]) { interventions }
  end

  def cached_contracts
    Rails.cache.fetch([self, "contracts"]) { contracts }
  end

  def cached_payments
    Rails.cache.fetch([self, "payments"]) { payments }
  end

  def cached_flush
    Rails.cache.delete([self,"supervisions"])
    Rails.cache.delete([self,"interventions"])
    Rails.cache.delete([self,"contracts"])
    Rails.cache.delete([self,"payments"])
  end
end
