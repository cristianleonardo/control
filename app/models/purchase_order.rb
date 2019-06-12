class PurchaseOrder < ApplicationRecord
  has_many :transactions
  has_many :purchase_input_orders
  has_many :inputs, through: :purchase_input_orders
  belongs_to :inventory
  belongs_to :user
  after_create :assign_inputs_to_inventory

  def assign_inputs_to_inventory
  	self.inventory.update(input_ids: self.inputs.pluck(:id))
  end

end
