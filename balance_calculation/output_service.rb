module BalanceCalculation
  class OutputService
    def self.call(report)
      new(report).call
    end

    def initialize(report)
      @report = report
    end

    def call
      report.each do |entry|
        print_item(entry)
      end
    end

    private

    attr_reader :report

    def print_item(entry)
      case entry[:type]
      when :item
        puts "#{entry[:quantity]} #{entry[:name]}: #{entry[:price_with_tax]}"
      when :sales_taxes
        puts "Sales Taxes: #{entry[:amount]}"
      when :total
        puts "Total: #{entry[:amount]}"
      end
    end
  end
end
