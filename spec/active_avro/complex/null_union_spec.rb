require 'spec_helper'
module ActiveAvro
  module Complex
    describe NullUnion do
      describe "#new" do
        subject { NullUnion.new(%w(one two three)) }
        its("length"){ should == 4 }
        its("last"){ should == 'null' }
      end
      describe "#to_partial_schema" do
        subject { NullUnion.new(%w(xyz)).to_partial_schema }
        it "should result in an array with two elements" do
          subject.should be_an(::Array)
          subject.length.should == 2
        end
      end

      describe "#cast" do
        subject { NullUnion.new([Enum.new(Gender)]) }
        it "should return the expected Gender attribute value" do
          subject.cast(Gender.new(name: 'Female')).should == 'Female'
        end
        it "should return nil for a nil instance" do
          subject.cast(nil).should be_nil
        end
      end
    end
  end
end