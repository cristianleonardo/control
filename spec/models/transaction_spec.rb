require 'rails_helper'

RSpec.describe Transaction, type: :model do
  it { should have_db_column(:user_id).of_type(:integer) }
  it { should have_db_column(:transactionable_id).of_type(:integer) }
  it { should have_db_column(:transactionable_type).of_type(:string) }
  it { should have_db_column(:amount).of_type(:decimal) }
  it { should have_db_column(:transaction_type).of_type(:string) }
  it { should have_db_column(:notes).of_type(:text) }


  it { should have_db_index(:transactionable_id) }
  it { should have_db_index(:transactionable_type) }
  it { should have_db_index(:user_id) }

  it { should belong_to(:transactionable) }
  it { should belong_to(:user) }

  it { should validate_presence_of(:amount) }
  it { should validate_presence_of(:transaction_type) }
  it { should validate_presence_of(:transactionable_id) }
  it { should validate_presence_of(:transactionable_type) }
  it { should validate_presence_of(:user_id) }
end
