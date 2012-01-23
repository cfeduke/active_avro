require 'spec_helper'
module ActiveAvro
  module Complex
    describe NullUnion do
      describe "#new" do
        subject { NullUnion.new(%w(one two three)) }
        its("length"){ should == 4 }
        its("last"){ should == 'null' }
      end
      describe "#to_hash" do
        subject { NullUnion.new(%w(xyz)).to_hash }
        it "should result in an array with two elements" do
          subject.should be_an(::Array)
          subject.length.should == 2
        end
      end
    end
  end
end