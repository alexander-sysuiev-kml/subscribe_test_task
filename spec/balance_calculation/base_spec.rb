require "spec_helper"
require_relative "../../balance_calculation/base"

RSpec.describe BalanceCalculation::Base do
  let(:csv_data) do
    <<~CSV
      name,quantity,price,type,imported
      book,1,12.49,book,no
    CSV
  end
  let(:expected_output) do
    <<~OUTPUT
      1 book: 12.49
      Sales Taxes: 0.0
      Total: 12.49
    OUTPUT
  end

  before do
    allow(File).to receive(:read).and_return(csv_data)
  end
  
  it "processes input and prints a report" do
    described_class.process

    expect($stdout.string).to eq(expected_output)
  end
end
