require "spec_helper"
require_relative "../../balance_calculation/output_service"

RSpec.describe BalanceCalculation::OutputService do
  let(:report) do
    [
      { type: :item, quantity: 1, name: "book", price_with_tax: 12.49 },
      { type: :sales_taxes, amount: 1.5 },
      { type: :total, amount: 28.98 }
    ]
  end

  it "prints each report entry to stdout" do
    described_class.call(report)

    expect($stdout.string).to eq(
      "1 book: 12.49\n" \
      "Sales Taxes: 1.5\n" \
      "Total: 28.98\n"
    )
  end
end
