require "spec_helper"
require_relative "../../balance_calculation/input_service"

RSpec.describe BalanceCalculation::InputService do
  let(:file_path) { "/tmp/input.csv" }

  context "when the file is valid" do
    let(:file_data) do
      <<~CSV
        name,quantity,price,type,imported
        book,2,12.49,book,yes
        music CD,1,14.99,other,no
        chocolate bar,1,0.85,food,
      CSV
    end

    before do
      allow(File).to receive(:read).with(file_path).and_return(file_data)
    end

    it "parses csv rows into stored entities" do
      entities = described_class.new(file_path).call

      expect(entities.size).to eq(3)
      expect(entities[0].name).to eq("book")
      expect(entities[0].quantity).to eq(2)
      expect(entities[0].price).to eq(12.49)
      expect(entities[0].type).to eq("book")
      expect(entities[0].imported).to eq(true)
      expect(entities[2].imported).to eq(false)
    end
  end

  context "when the file is missing" do
    before do
      allow(File).to receive(:read).with(file_path).and_raise(Errno::ENOENT)
    end

    it "raises an error" do
      expect { described_class.new(file_path).call }
        .to raise_error(ArgumentError, "Input file not found: #{file_path}")
    end
  end

  context "when the csv data is malformed" do
    let(:file_data) { "name,quantity\n\"broken" }

    before do
      allow(File).to receive(:read).with(file_path).and_return(file_data)
    end

    it "raises an error" do
      expect { described_class.new(file_path).call }
        .to raise_error(ArgumentError, /Invalid CSV input:/)
    end
  end

  context "when the required fields are missing" do
    let(:file_data) do
      <<~CSV
      name,quantity,price,type,imported
      book,,12.49,book,no
      CSV
    end

    before do
      allow(File).to receive(:read).with(file_path).and_return(file_data)
    end

    it "raises an error" do
      expect { described_class.new(file_path).call }
        .to raise_error(ArgumentError, "Missing required fields: quantity")
    end
  end
end
