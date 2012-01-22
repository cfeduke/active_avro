require 'spec_helper'

module ActiveAvro
  module Complex
    describe Record do
      describe "#new" do
        it "sets the name to the klass's name" do
          Record.new(Person).name == 'Person'
        end
      end

      describe Record::Field do
        describe "self#from_column" do
          subject { Record::Field.from_column(Person.columns.find { |c| c.name == 'name' }) }
          its("name") { should == 'name' }
          its("type") { should == :string }
        end
      end

    end
  end
end