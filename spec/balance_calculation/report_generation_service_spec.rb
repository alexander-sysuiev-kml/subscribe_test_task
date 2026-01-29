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
  let(:expected_output) do
    <<~OUTPUT
      1 book: 12.49
      1 music CD: 16.49
      Sales Taxes: 1.5
      Total: 28.98
    OUTPUT
  end

  it "prints line items and totals based on taxes" do
    described_class.call(entities)

    expect($stdout.string).to eq(expected_output)
  end
end
