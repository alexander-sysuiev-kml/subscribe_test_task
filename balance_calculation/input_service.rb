require_relative "./line_item"

module BalanceCalculation
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
        LineItem.new(
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
      return false if normalized_value.empty?
      return true if %w[true 1 yes y].include?(normalized_value)
      return false if %w[false 0 no n].include?(normalized_value)

      raise ArgumentError, "Invalid boolean value for imported: #{value}"
    end
  end
end
