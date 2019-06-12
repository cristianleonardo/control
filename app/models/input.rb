class Input < ApplicationRecord
  has_many :inventory_inputs
  has_many :inventories, through: :inventory_inputs
  has_many :provider_inputs
  has_many :providers, through: :provider_inputs
  has_many :purchase_input_orders
  has_many :purchase_orders, through: :purchase_input_orders
end
