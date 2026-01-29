module BalanceCalculation
  class Base
    DEFAULT_FILE_PATH = "input.csv".freeze

    def self.process(file_path = DEFAULT_FILE_PATH)
      input_service = InputService.new(file_path)
      stored_entities = input_service.call

      ReportGenerationService.call(stored_entities)
    end
  end

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
        total_tax += entity.tax_amount
        total_sum += entity.price_with_tax

        puts "#{entity.quantity} #{entity.name}: #{entity.price_with_tax}"
      end

      puts "Sales Taxes: #{total_tax}"
      puts "Total: #{total_sum}"
    end

    private

    attr_reader :stored_entities
  end

  class TaxCalculationService
    attr_reader :stored_entity
    EXEMPT_TYPES = %w[book food medical].freeze

    def self.call(stored_entity)
      new(stored_entity).call
    end

    def initialize(stored_entity)
      @stored_entity = stored_entity
    end

    def call
      round_tax(tax_rate * price)
    end

    private

    def round_tax(tax_value)
      # Nice trick from the internet to round to the nearest 0.05
      (tax_value * 20).round / 20.0
    end

    def tax_rate
      return 0.05 if stored_entity.imported
      return 0 if EXEMPT_TYPES.include?(stored_entity.type)

      return 0.10
    end
  end

  class StoredEntity
    attr_reader :name, :quantity, :price, :imported, :type

    def initialize(name:, quantity:, price:, type:, imported: false)
      @name = name
      @quantity = quantity
      @price = price
      @imported = imported
      @type = type
    end

    def price_with_tax
      @price_with_tax ||= calculated_price + tax_amount
    end

    def calculated_price
      @calculated_price ||= price * quantity
    end

    def tax_amount
      @tax_amount ||= TaxCalculationService.call(self)
    end
  end

  class InputService
    REQUIRED_FIELDS = %w[name quantity price type].freeze

    def initialize(file_path)
      @file_path = file_path
    end

    def call
      data = read_file_data
      rows = parse_csv(data)

      rows.map do |row|
        validate_row!(row)
        StoredEntity.new(
          name: row["name"],
          quantity: Integer(row["quantity"]),
          price: Float(row["price"]),
          type: row["type"],
          imported: parse_boolean(row["imported"])
        )
      end
    end

    private

    def read_file_data
      File.read(@file_path)
    rescue Errno::ENOENT
      raise ArgumentError, "Input file not found: #{@file_path}"
    end

    def parse_csv(data)
      require "csv"
      CSV.parse(data, headers: true).map(&:to_h)
    rescue CSV::MalformedCSVError => e
      raise ArgumentError, "Invalid CSV input: #{e.message}"
    end

    def validate_row!(row)
      missing = REQUIRED_FIELDS.select do |field|
        row[field].nil? || row[field].to_s.strip.empty?
      end

      return if missing.empty?

      raise ArgumentError, "Missing required fields: #{missing.join(', ')}"
    end

    def parse_boolean(value)
      normalized_value = value.to_s.strip.downcase
      return false if normalized_value.nil? || normalized_value.empty?
      return true if %w[true 1 yes y].include?(normalized_value)
      return false if %w[false 0 no n].include?(normalized_value)

      raise ArgumentError, "Invalid boolean value for imported: #{value}"
    end
  end
end

BalanceCalculation::Base.process
