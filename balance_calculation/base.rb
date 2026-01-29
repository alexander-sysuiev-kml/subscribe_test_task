require_relative "./input_service"
require_relative "./report_generation_service"

module BalanceCalculation
  class Base
    DEFAULT_FILE_PATH = "input.csv".freeze

    def self.process(file_path = DEFAULT_FILE_PATH)
      input_service = InputService.new(file_path)
      stored_entities = input_service.call

      ReportGenerationService.call(stored_entities)
    end
  end
end
