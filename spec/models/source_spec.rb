require 'rails_helper'

RSpec.describe Source, type: :model do
  it { should have_db_column(:name).of_type(:string) }
  it { should have_db_column(:description).of_type(:string) }
  it { should have_db_column(:general_source_id).of_type(:integer) }
  it { should have_db_column(:source_type).of_type(:string) }

  # it { should have_db_index(:general_source_id) }

  # it { should belong_to(:general_source) }
  it { should have_many(:incomes) }
  it { should have_many(:designates) }
  it { should have_many(:certificates) }

  it { should validate_presence_of(:name) }
end
