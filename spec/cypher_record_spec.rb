# frozen_string_literal: true

RSpec.describe CypherRecord do
  it "has a version number" do
    expect(CypherRecord::VERSION).not_to be nil
  end
end
