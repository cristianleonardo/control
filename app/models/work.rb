class Work < ApplicationRecord
  belongs_to :work_type
  belongs_to :inventory
  has_many :contracts
end
