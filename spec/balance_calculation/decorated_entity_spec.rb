require "spec_helper"
require_relative "../../balance_calculation/decorated_entity"
require_relative "../../balance_calculation/line_item"

RSpec.describe BalanceCalculation::DecoratedEntity do
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
    decorated = described_class.new(line_item)

    expect(decorated.name).to eq("music CD")
    expect(decorated.quantity).to eq(1)
    expect(decorated.tax_amount).to eq(1.5)
    expect(decorated.price_with_tax.round(2)).to eq(16.49)
  end
end
