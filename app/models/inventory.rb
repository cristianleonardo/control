class Inventory < ApplicationRecord
  has_many :inventory_inputs
  has_many :inputs, through: :inventory_inputs
  has_many :purchase_orders
  belongs_to :work
end
