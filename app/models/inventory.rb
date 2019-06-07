class Inventory < ApplicationRecord
  has_many :inventory_inputs
  has_many :purchase_orders
  has_many :works
end
