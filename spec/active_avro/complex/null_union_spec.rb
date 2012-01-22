require 'spec_helper'
module ActiveAvro
  module Complex
    describe NullUnion do
      subject { NullUnion.new(%w(one two three)) }
      its("length"){ should == 4 }
      its("last"){ should == 'null' }
    end
  end
end