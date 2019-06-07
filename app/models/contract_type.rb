class ContractType < ApplicationRecord
  has_many :contracts
  has_many :subcontracts

  validates_presence_of :abbreviation
  validates_presence_of :name
end
