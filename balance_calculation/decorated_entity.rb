require_relative "./tax_calculation_service"

module BalanceCalculation
  class DecoratedEntity
    attr_reader :stored_entity

    def initialize(stored_entity)
      @stored_entity = stored_entity
    end

    def price_with_tax
      @price_with_tax ||= stored_entity.full_price + tax_amount
    end

    def tax_amount
      @tax_amount ||= TaxCalculationService.call(stored_entity)
    end

    def quantity
      @quantity ||= stored_entity.quantity
    end

    def name
      @name ||= stored_entity.name
    end
  end
end
