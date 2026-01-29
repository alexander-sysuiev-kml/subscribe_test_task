require "rspec"
require "stringio"

RSpec.configure do |config|
  config.around(:each) do |example|
    original_stdout = $stdout
    $stdout = StringIO.new
    begin
      example.run
    ensure
      $stdout = original_stdout
    end
  end
end
