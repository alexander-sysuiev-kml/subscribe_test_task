require "spec_helper"
require_relative "../../balance_calculation/tax_calculation_service"
require_relative "../../balance_calculation/line_item"

RSpec.describe BalanceCalculation::TaxCalculationService do
  let(:type) { "book" }
  let(:imported) { false }

  let(:entity) do
    BalanceCalculation::LineItem.new(
      name: "book",
      quantity: 1,
      price: 12.49,
      type: type,
      imported: imported
    )
  end

  context "when the item is exempt, non-imported" do
    let(:type) { "book" }
    let(:imported) { false }

    it "applies no tax" do
      expect(described_class.call(entity)).to eq(0.0)
    end
  end

  context "when the item is non-exempt" do
    let(:type) { "other" }
    let(:imported) { false }

    it "applies base tax" do
      expect(described_class.call(entity)).to eq(1.25)
    end
  end
  context "when the item is imported" do
    let(:imported) { true }
    let(:type) { "book" }

    it "applies import tax" do
      expect(described_class.call(entity)).to eq(0.6)
    end
  end
  context "when the item is imported and non-exempt" do
    let(:imported) { true }
    let(:type) { "other" }

    it "applies import and base tax" do
      expect(described_class.call(entity)).to eq(1.85)
    end
  end
end
