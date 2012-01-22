require 'spec_helper'

module ActiveAvro
  module Complex
    describe Record do
      describe "#type" do
        it "is always 'record'" do
          Record.new(Person).type.should == 'record'
        end
      end
      describe "#new" do
        context "when using the Person class" do
          subject { Record.new(Person) }
          it "sets the name to the class' name" do
            subject.name == 'Person'
          end
          it "creates all the expected fields" do
            subject.fields.length.should == (Person.columns.length + Person.reflections.length)
          end
          it "creates the column-based fields" do
            subject.fields.find{ |f| f.name == 'name' }.type == :string
          end
          it "creates the relationship-based fields" do
            pets = subject.fields.find{ |f| f.name == 'pets' }
            pets.type.type.should == 'record'
            pets.type.embedded?.should be_true
          end
          it "doesn't remap known types as embedded types" do

          end
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