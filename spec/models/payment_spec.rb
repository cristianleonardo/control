require 'rails_helper'

RSpec.describe Payment, type: :model do
  subject { described_class.new }
  it "is valid with valid attributes" do
    subject.value = 3000000
    subject.prepayment_appliance = 1000000
    subject.save
    expect(subject).to be_valid
  end
end
