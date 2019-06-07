require 'rails_helper'

RSpec.describe Income, type: :model do
  it { should have_db_column(:code).of_type(:string) }
  it { should have_db_column(:description).of_type(:text) }
  it { should have_db_column(:income_value).of_type(:decimal) }
  it { should have_db_column(:income_date).of_type(:datetime) }
  it { should have_db_column(:incomeable_id).of_type(:integer) }
  it { should have_db_column(:incomeable_type).of_type(:string) }

  # it { should belong_to(:incomeable) }
end
