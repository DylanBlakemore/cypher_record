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
end
