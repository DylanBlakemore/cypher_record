# frozen_string_literal: true

RSpec.describe CypherRecord do
  it "has a version number" do
    expect(CypherRecord::VERSION).not_to be nil
  end

  it "can configure the driver" do
    CypherRecord.configure do |config|
      config.driver = CypherRecord::Driver.new
    end

    expect(CypherRecord.driver).to be_a(CypherRecord::Driver)
  end

  it "raises an error when an invalid driver is defined" do
    expect { CypherRecord.configure { |config| config.driver = "foo" } }.to raise_error(ArgumentError, "Database driver should be a CypherRecord::Driver")
  end
end
