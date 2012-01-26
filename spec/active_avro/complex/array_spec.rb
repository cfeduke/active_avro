require 'spec_helper'

module ActiveAvro
  module Complex
    describe Array do
      describe "#new" do
        it "initializes the type items attribute appropriately" do
          ActiveAvro::Complex::Array.new(!nil).items.should_not be_nil
        end
      end
      describe "#to_hash" do
        context "when its a primitive type" do
          subject { ActiveAvro::Complex::Array.new(TypeConverter.to_avro(:string)).to_partial_schema }
          its([:items]) { should == "string" }
        end
        context "when its a record and that record is the root class" do
          subject { ActiveAvro::Complex::Array.new(Record.new(Person)).to_partial_schema }
          #its([:items]) { should == 'Person'} since Person is the root class this isn't correct
        end
      end
    end

  end
end