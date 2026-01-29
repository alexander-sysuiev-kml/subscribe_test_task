require_relative "./decorated_entity"

module BalanceCalculation
  class ReportGenerationService
    def self.call(stored_entities)
      new(stored_entities).call
    end

    def initialize(stored_entities)
      @stored_entities = stored_entities
    end

    def call
      total_tax = 0
      total_sum = 0
      stored_entities.each do |entity|
        decorated_entity = DecoratedEntity.new(entity)
        total_tax += decorated_entity.tax_amount
        total_sum += decorated_entity.price_with_tax

        puts "#{decorated_entity.quantity} #{decorated_entity.name}: #{decorated_entity.price_with_tax.round(2)}"
      end

      puts "Sales Taxes: #{total_tax.round(2)}"
      puts "Total: #{total_sum.round(2)}"
    end

    private

    attr_reader :stored_entities
  end
end
