require_relative "./taxed_line_item"

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
        taxed_line_item = TaxedLineItem.new(line_item)
        total_tax += taxed_line_item.tax_amount
        total_sum += taxed_line_item.price_with_tax

        puts "#{taxed_line_item.quantity} #{taxed_line_item.name}: #{taxed_line_item.price_with_tax.round(2)}"
      end

      puts "Sales Taxes: #{total_tax.round(2)}"
      puts "Total: #{total_sum.round(2)}"
    end

    private

    attr_reader :line_items
  end
end
