require 'spec_helper'

module ActiveAvro
  module Complex
    describe Array do
      describe "#new" do
        it "initializes the type items attribute appropriately" do
          ActiveAvro::Complex::Array.new(!nil).items.should_not be_nil
        end
      end
      describe "#to_partial_schema" do
        context "when its a primitive type" do
          subject { ActiveAvro::Complex::Array.new(TypeConverter.to_avro(:string)).to_partial_schema }
          its([:items]) { should == "string" }
        end
        context "when its a record and that record is the root class" do
          subject { ActiveAvro::Complex::Array.new(Record.new(Person)).to_partial_schema }
          #its([:items]) { should == 'Person'} since Person is the root class this isn't correct
        end
      end

      describe "#cast" do
        context "when its a primitive type" do
          let(:values) { [1,2,3] }
          subject { ActiveAvro::Complex::Array.new(TypeConverter.to_avro(:integer)).cast(values) }
          it { should == [1,2,3] }
        end
        context "when its a complex type" do
          let(:values) { [Dma.new(zip_code: '13905'), Dma.new(zip_code: '22407')] }
          subject { ActiveAvro::Complex::Array.new(Enum.new(Dma, name_attribute_name: 'zip_code')).cast(values) }
          it { should == %w(13905 22407) }
        end
      end
    end

  end
end