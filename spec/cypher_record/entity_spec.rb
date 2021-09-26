require "spec_helper"

RSpec.describe CypherRecord::Entity do
  
  class DummyCypherEntityClass < CypherRecord::Entity

    properties :req_1, :req_2, opt_1: nil, opt_2: "foo"

  end

  let(:klass) { DummyCypherEntityClass }

  it "raises an exception if the required properties have not been defined" do
    expect { klass.new(:n, req_1: "bar") }.to raise_error(ArgumentError, "Required properties req_2 missing for DummyCypherEntityClass")
  end

  let(:entity) { klass.new(:n, req_1: 1, req_2: 2, opt_1: "bar") }

  it "assigns the correct instance variables" do
    expect(entity.req_1).to eq(1)
    expect(entity.req_2).to eq(2)
    expect(entity.opt_1).to eq("bar")
    expect(entity.opt_2).to eq("foo")
  end

  describe "#type" do
    it "returns the class name" do
      expect(entity.type).to eq("DummyCypherEntityClass")
    end
  end

  describe "#property_string" do
    let(:property_string) do
      "{req_1: 1, req_2: 2, opt_1: 'bar', opt_2: 'foo'}"
    end

    it "returns the correctly formatted property string" do
      expect(entity.property_string).to eq(property_string)
    end
  end
end
