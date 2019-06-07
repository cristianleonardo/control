require 'rails_helper'

RSpec.describe ContractType, type: :model do
  # Model validations
  it { should validate_presence_of(:abbreviation) }
  it { should validate_presence_of(:name) }

  #Basic DB
  it { should have_db_column(:abbreviation).of_type(:string).with_options(null: false, default: "") }
  it { should have_db_column(:name).of_type(:string).with_options(null: false, default: "") }

  ## System
  it { should have_db_column(:id).of_type(:integer) }
  it { should have_db_column(:created_at).of_type(:datetime) }
  it { should have_db_column(:updated_at).of_type(:datetime) }
end
