class Input < ApplicationRecord
  has_many :inventory_inputs
  has_many :provider_inputs
  has_many :providers, through: :providers
  has_many :purchase_input_orders
end
