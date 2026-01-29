require_relative "./decorated_entity"

module BalanceCalculation
  class ReportGenerationService
    def self.call(line_items)
      new(line_items).call
    end

    def initialize(line_items)
      @line_items = line_items
    end

    def call
      total_tax = 0
      total_sum = 0
      line_items.each do |line_item|
        decorated_entity = DecoratedEntity.new(line_item)
        total_tax += decorated_entity.tax_amount
        total_sum += decorated_entity.price_with_tax

        puts "#{decorated_entity.quantity} #{decorated_entity.name}: #{decorated_entity.price_with_tax.round(2)}"
      end

      puts "Sales Taxes: #{total_tax.round(2)}"
      puts "Total: #{total_sum.round(2)}"
    end

    private

    attr_reader :line_items
  end
end
