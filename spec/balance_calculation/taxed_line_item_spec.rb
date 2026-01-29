require "spec_helper"
require_relative "../../balance_calculation/taxed_line_item"
require_relative "../../balance_calculation/line_item"

RSpec.describe BalanceCalculation::TaxedLineItem do
  let(:line_item) do
    BalanceCalculation::LineItem.new(
      name: "music CD",
      quantity: 1,
      price: 14.99,
      type: "other",
      imported: false
    )
  end

  it "exposes line item data and calculated tax" do
    taxed_line_item = described_class.new(line_item)

    expect(taxed_line_item.name).to eq("music CD")
    expect(taxed_line_item.quantity).to eq(1)
    expect(taxed_line_item.tax_amount).to eq(1.5)
    expect(taxed_line_item.price_with_tax.round(2)).to eq(16.49)
  end
end
