require "spec_helper"
require_relative "../../balance_calculation/report_generation_service"
require_relative "../../balance_calculation/line_item"

RSpec.describe BalanceCalculation::ReportGenerationService do
  let(:entity1) do
    BalanceCalculation::LineItem.new(
      name: "book",
      quantity: 1,
      price: 12.49,
      type: "book",
      imported: false
    )
  end
  let(:entity2) do
    BalanceCalculation::LineItem.new(
      name: "music CD",
      quantity: 1,
      price: 14.99,
      type: "other",
      imported: false
    )
  end
  let(:entities) { [entity1, entity2] }
  let(:expected_report) do
    [
      { type: :item, quantity: 1, name: "book", price_with_tax: 12.49 },
      { type: :item, quantity: 1, name: "music CD", price_with_tax: 16.49 },
      { type: :sales_taxes, amount: 1.5 },
      { type: :total, amount: 28.98 }
    ]
  end

  it "returns line items and totals based on taxes" do
    report = described_class.call(entities)

    expect(report).to eq(expected_report)
  end
end
