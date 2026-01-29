require_relative "./tax_calculation_service"

module BalanceCalculation
  class StoredEntity
    attr_reader :name, :quantity, :price, :imported, :type

    def initialize(name:, quantity:, price:, type:, imported: false)
      @name = name
      @quantity = quantity
      @price = price
      @imported = imported
      @type = type
    end

    def full_price
      @full_price ||= price * quantity
    end
  end
end
