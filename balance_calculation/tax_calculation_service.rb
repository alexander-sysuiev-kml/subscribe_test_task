module BalanceCalculation
  class TaxCalculationService
    attr_reader :line_item
    EXEMPT_TYPES = %w[book food medical].freeze
    IMPORT_TAX_RATE = 0.05
    BASE_TAX_RATE = 0.10

    def self.call(line_item)
      new(line_item).call
    end

    def initialize(line_item)
      @line_item = line_item
    end

    def call
      round_tax(tax_rate * line_item.price) * line_item.quantity
    end

    private

    def round_tax(tax_value)
      # Nice trick from the internet to round up to the nearest 0.05 (never round down)
      (tax_value * 20).ceil / 20.0
    end

    def tax_rate
      base_tax = 0
      base_tax += BASE_TAX_RATE unless EXEMPT_TYPES.include?(line_item.type)
      base_tax += IMPORT_TAX_RATE if line_item.imported

      base_tax
    end
  end
end
