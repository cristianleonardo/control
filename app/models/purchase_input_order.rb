class PurchaseInputOrder < ApplicationRecord
  belongs_to :purchase_order
  belongs_to :input
end
