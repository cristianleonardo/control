class PurchaseOrder < ApplicationRecord
  has_many :transactions
  has_many :purchase_input_orders
  belongs_to :inventory
  belongs_to :user
end
