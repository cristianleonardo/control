class Subcontract < ApplicationRecord
  has_many :payments
  has_many :medias, dependent: :destroy
  belongs_to :contractor, :class_name => 'Contractor', :foreign_key => 'contractor_id'
  belongs_to :interventor, :class_name => 'Contractor', :foreign_key => 'interventor_contractor_id', optional: true
  belongs_to :supervisor, :class_name => 'Contractor', :foreign_key => 'supervisor_contractor_id', optional: true
  belongs_to :contract_type
  belongs_to :contract
end
