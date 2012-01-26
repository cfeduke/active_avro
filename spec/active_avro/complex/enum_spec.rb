require 'spec_helper'

module ActiveAvro
  module Complex
    describe Enum do
      describe '#initialize' do
        context "when passed values" do
          subject { Enum.new(Choice, zero_name: 'zero_name', value_attribute_name: 'van', name_attribute_name: 'nan') }
          its('zero_name') { should == 'zero_name' }
          its('value_attribute_name') { should == 'van' }
          its('name_attribute_name') { should == 'nan' }
        end
        context "when no initialization values are passed" do
          subject { Enum.new(nil, { }) }
          its('zero_name') { should == Enum::DEFAULT_ZERO_NAME }
          its('value_attribute_name') { should == Enum::DEFAULT_VALUE_ATTRIBUTE_NAME }
          its('name_attribute_name') { should == Enum::DEFAULT_NAME_ATTRIBUTE_NAME }
        end
      end

      describe '#get_values' do
        context "when using a lookup table with no 0 value" do
          subject { Enum.new(Choice).get_values }
          its('length') { should == 3 } # Unknown, Yes, No
          its('first') { should == { value: 0, name: Enum::DEFAULT_ZERO_NAME } }
          its('last') { should == { value: 2, name: 'No' } }
        end
        context "when using a lookup table with a specified 0 value" do
          subject { Enum.new(Gender).get_values }
          its('length') { should == 3 } # (All), Male, Female
          its('first') { should == { value: 0, name: '(All)' } }
          its('last') { should == { value: 2, name: 'Female' } }
        end
        context "when using a lookup table with non-default columns" do
          subject { Enum.new(Dma, value_attribute_name: 'dma_id', name_attribute_name: 'zip_code').get_values }
          its('length') { should == 3 }
          its('first') { should == { value: 0, name: 'Unknown' } }
          its('last') { should == { value: 301, name: '22407' } }
        end
      end
    end
  end
end