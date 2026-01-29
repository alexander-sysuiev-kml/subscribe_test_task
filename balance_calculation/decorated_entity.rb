require_relative "./tax_calculation_service"

module BalanceCalculation
  class DecoratedEntity
    attr_reader :line_item

    def initialize(line_item)
      @line_item = line_item
    end

    def price_with_tax
      @price_with_tax ||= line_item.full_price + tax_amount
    end

    def tax_amount
      @tax_amount ||= TaxCalculationService.call(line_item)
    end

    def quantity
      @quantity ||= line_item.quantity
    end

    def name
      @name ||= line_item.name
    end
  end
end
