require "spec_helper"
require_relative "../../balance_calculation/decorated_entity"
require_relative "../../balance_calculation/stored_entity"

RSpec.describe BalanceCalculation::DecoratedEntity do
  let(:stored_entity) do
    BalanceCalculation::StoredEntity.new(
      name: "music CD",
      quantity: 1,
      price: 14.99,
      type: "other",
      imported: false
    )
  end

  it "exposes stored entity data and calculated tax" do
    decorated = described_class.new(stored_entity)

    expect(decorated.name).to eq("music CD")
    expect(decorated.quantity).to eq(1)
    expect(decorated.tax_amount).to eq(1.5)
    expect(decorated.price_with_tax.round(2)).to eq(16.49)
  end
end
