# frozen_string_literal: true

RSpec.describe CypherRecord do
  it "has a version number" do
    expect(CypherRecord::VERSION).not_to be nil
  end

  it "can configure the engine" do
    CypherRecord.configure do |config|
      config.engine = CypherRecord::Engine.new
    end

    expect(CypherRecord.engine).to be_a(CypherRecord::Engine)
  end

  it "raises an error when an invalid engine is defined" do
    expect { CypherRecord.configure { |config| config.engine = "foo" } }.to raise_error(ArgumentError, "Database engine should be a CypherRecord::Engine")
  end
end
