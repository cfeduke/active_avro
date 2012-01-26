require 'spec_helper'

module ActiveAvro
  module Complex
    describe Enum do
      describe '#initialize' do
        context "when passed values" do
          subject { Enum.new(zero_name: 'zero_name', value_attribute_name: 'van', name_attribute_name: 'nan') }
          its('zero_name') { should == 'zero_name' }
          its('value_attribute_name') { should == 'van' }
          its('name_attribute_name') { should == 'nan' }
        end
        context "when no initialization values are passed" do
          subject { Enum.new }
          its('zero_name') { should == Enum::DEFAULT_ZERO_NAME }
          its('value_attribute_name') { should == Enum::DEFAULT_VALUE_ATTRIBUTE_NAME }
          its('name_attribute_name') { should == Enum::DEFAULT_NAME_ATTRIBUTE_NAME }
        end

      end
    end
  end
end