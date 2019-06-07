class Transaction < ApplicationRecord
  belongs_to :inventory
  belongs_to :user
  belongs_to :purchase_order

  validates_presence_of :transaction_type
  validates_presence_of :user_id
end
