require 'spec_helper'

module ActiveAvro
  module Complex
    describe Union do
      describe "#new" do
        it "initializes with the specified arguments" do
          Union.new(%w(one two three)).length.should == 3
        end

        describe "#cast" do
          context "when only one primitive type is specified" do
            subject { Union[:string].cast('blah') }
            it { should == 'blah' }
          end
          context "when multiple primitive types are specified" do
            subject { Union[:string, :integer].cast(12) }
            it { should == 12 }
          end
          context "when one complex type is specified" do
            subject { Union[Enum.new(Gender)].cast(Gender.new(name: 'Female')) }
            it { should == 'Female' }
          end
          context "when multiple complex types are specified" do
            subject { Union[Enum.new(Gender), Enum.new(Choice)].cast(Choice.new(name: 'Yes')) }
            it { should == 'Yes' }
          end
          context "when a combinations of complex and primitives are specified" do
            let(:union) { Union[Enum.new(Choice), :integer, Enum.new(Gender)] }
            it "should return an integer value" do
              union.cast(14).should == 14
            end
            it "should return the expected Gender name attribute value" do
              union.cast(Gender.new(name: 'Male')).should == 'Male'
            end
          end
          context "when a record is specified" do
            subject { Union[Record.new(Person)].cast(Person.find_by_name('Charles')) }
            it { should be_a Hash }
          end
        end
      end
    end
  end
end