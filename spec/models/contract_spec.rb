require 'rails_helper'

RSpec.describe Contract, type: :model do
  # Basic DB
  it { should have_db_column(:contract_number).of_type(:string).with_options(null: false) }
  it { should have_db_column(:process_number).of_type(:string).with_options(null: false) }
  it { should have_db_column(:contractual_object).of_type(:string) }
  it { should have_db_column(:observations).of_type(:text) }
  it { should have_db_column(:suscription_date).of_type(:datetime) }
  it { should have_db_column(:start_date).of_type(:datetime) }
  it { should have_db_column(:settlement_date).of_type(:datetime) }
  it { should have_db_column(:initial_value).of_type(:decimal).with_options(null: false) }
  it { should have_db_column(:city_id).of_type(:integer).with_options(null: false) }
  it { should have_db_column(:mode).of_type(:string).with_options(null: false) }
  it { should have_db_column(:state).of_type(:string).with_options(null: false) }
  it { should have_db_column(:term_days).of_type(:integer) }
  it { should have_db_column(:term_months).of_type(:integer) }
  it { should have_db_column(:interventor_contractor_id).of_type(:integer) }
  it { should have_db_column(:supervisor_contractor_id).of_type(:integer) }
  it { should have_db_column(:contractor_id).of_type(:integer).with_options(null: false) }
  it { should have_db_column(:contract_type_id).of_type(:integer).with_options(null: false) }
  it { should have_db_column(:created_at).of_type(:datetime).with_options(null: false) }
  it { should have_db_column(:updated_at).of_type(:datetime).with_options(null: false) }

  ## System
  it { should have_db_column(:id).of_type(:integer) }
  it { should have_db_column(:created_at).of_type(:datetime) }
  it { should have_db_column(:updated_at).of_type(:datetime) }
end
