require "spec_helper"
require_relative "../../balance_calculation/tax_calculation_service"
require_relative "../../balance_calculation/line_item"

RSpec.describe BalanceCalculation::TaxCalculationService do
  let(:type) { "other" }
  let(:imported) { false }
  let(:price) { 12.49 }
  let(:quantity) { 1 }

  let(:entity) do
    BalanceCalculation::LineItem.new(
      name: "book",
      quantity: quantity,
      price: price,
      type: type,
      imported: imported
    )
  end

  context "when the price is not a multiple of 0.05" do
    let(:price) { 15.10 }

    it "rounds tax up to the nearest 0.05" do
      expect(described_class.call(entity)).to eq(1.55)
    end
  end

  context "when multiple line items" do
    let(:quantity) { 2 }
    let(:price) { 0.21 }

    it "rounds per unit before applying quantity" do
      expect(described_class.call(entity)).to eq(0.10)
    end
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
      expect(described_class.call(entity)).to eq(0.65)
    end
  end
  context "when the item is imported and non-exempt" do
    let(:imported) { true }
    let(:type) { "other" }

    it "applies import and base tax" do
      expect(described_class.call(entity)).to eq(1.9)
    end
  end
end
