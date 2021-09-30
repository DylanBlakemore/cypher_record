require "spec_helper"

RSpec.describe CypherRecord::ClassResolver do

  before do
    module Namespace; end
    class DummyResolutionClass; end
    class DummyCallerClass; end
    class Namespace::DummyNamespacedResolutionClass; end
    class Namespace::DummyNamespacedCallerClass; end
  end

  describe ".from_key" do
    it "returns the class for a non-namespaced class" do
      expect(described_class.resolve(:dummy_resolution_class, DummyCallerClass)).to eq(DummyResolutionClass)
    end

    it "returns the class for a namespaced class" do
      expect(described_class.resolve(:dummy_namespaced_resolution_class, Namespace::DummyNamespacedCallerClass)).to eq(Namespace::DummyNamespacedResolutionClass)
    end

    it "returns a non-namespaced class if there is nothing in the matching namespace" do
      expect(described_class.resolve(:dummy_resolution_class, Namespace::DummyNamespacedCallerClass)).to eq(DummyResolutionClass)
    end

    it "raises an exception if it can't resolve the class" do
      expect { described_class.resolve(:missing, Namespace::DummyNamespacedCallerClass) }.to raise_error(CypherRecord::EntityTypeError, "Class not found for entity Missing")
    end
  end

end
