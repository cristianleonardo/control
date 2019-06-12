class Work < ApplicationRecord
  belongs_to :work_type
  has_many :inventories
  has_many :contracts
end
