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
      report = []
      line_items.each do |line_item|
        taxed_line_item = TaxedLineItem.new(line_item)
        total_tax += taxed_line_item.tax_amount
        total_sum += taxed_line_item.price_with_tax

        report << {
          type: :item,
          quantity: taxed_line_item.quantity,
          name: taxed_line_item.name,
          price_with_tax: taxed_line_item.price_with_tax.round(2)
        }
      end

      report << { type: :sales_taxes, amount: total_tax.round(2) }
      report << { type: :total, amount: total_sum.round(2) }

      report
    end

    private

    attr_reader :line_items
  end
end
