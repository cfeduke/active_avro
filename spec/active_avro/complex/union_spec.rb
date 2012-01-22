require 'spec_helper'

module ActiveAvro
  module Complex
    describe Union do
      describe "#new" do
        it "initializes with the specified arguments" do
          Union.new(%w(one two three)).length.should == 3
        end
      end
    end
  end
end