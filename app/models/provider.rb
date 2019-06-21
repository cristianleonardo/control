class Provider < ApplicationRecord
  has_many :provider_inputs
  has_many :inputs, through: :provider_inputs
end
