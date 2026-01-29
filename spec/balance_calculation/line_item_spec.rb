require "spec_helper"
require_relative "../../balance_calculation/line_item"

RSpec.describe BalanceCalculation::LineItem do
  let(:attributes) do
    {
      name: "chocolate bar",
      quantity: 3,
      price: 0.85,
      type: "food",
      imported: false
    }
  end

  it "calculates full price from quantity and price" do
    entity = described_class.new(**attributes)

    expect(entity.full_price).to eq(2.55)
    expect(entity.name).to eq("chocolate bar")
    expect(entity.quantity).to eq(3)
    expect(entity.price).to eq(0.85)
    expect(entity.type).to eq("food")
    expect(entity.imported).to eq(false)
  end
end
