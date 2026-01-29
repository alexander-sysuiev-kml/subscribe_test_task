module BalanceCalculation
  class TaxCalculationService
    attr_reader :stored_entity
    EXEMPT_TYPES = %w[book food medical].freeze
    IMPORT_TAX_RATE = 0.05
    BASE_TAX_RATE = 0.10

    def self.call(stored_entity)
      new(stored_entity).call
    end

    def initialize(stored_entity)
      @stored_entity = stored_entity
    end

    def call
      round_tax(tax_rate * stored_entity.full_price)
    end

    private

    def round_tax(tax_value)
      # Nice trick from the internet to round to the nearest 0.05
      (tax_value * 20).round / 20.0
    end

    def tax_rate
      base_tax = 0
      base_tax += BASE_TAX_RATE unless EXEMPT_TYPES.include?(stored_entity.type)
      base_tax += IMPORT_TAX_RATE if stored_entity.imported

      base_tax
    end
  end
end
