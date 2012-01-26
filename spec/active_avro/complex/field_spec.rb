require 'spec_helper'

module ActiveAvro
  module Complex
    describe Field do
      describe "self#from_column" do
        subject { Field.from_column(Person.columns.find { |c| c.name == 'name' }) }
        its("name") { should == 'name' }
        its("type") { should == :string }
      end
      describe "#to_hash" do
        subject { Field.new('xyz', TypeConverter.to_avro(:integer)).to_partial_schema }
        its([:name]) { should == 'xyz' }
        context "when type is a symbol" do
          its([:type]) { should == TypeConverter.to_avro(:integer).to_s }
        end
        context "when type is a record" do
          subject { Field.new('xyz', Record.new(Pet)).to_partial_schema }
          its([:type]){ should be_a Hash }
        end
        context "when type is an enum" do
          subject { Field.new('gender', Enum.new(Gender)).to_partial_schema }
          its([:type]){ should be_a Hash }
          its([:name]){ should == 'gender' }
          it "should have the expected enumerated values" do
            e = subject[:type]
            e[:type].should == 'enum'
            e[:name].should == 'Gender'
            e[:symbols].should == %w((All) Male Female)
          end
        end
      end
    end
  end
end