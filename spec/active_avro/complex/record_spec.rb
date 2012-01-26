require 'spec_helper'

module ActiveAvro
  module Complex
    describe Record do
      describe "#type" do
        it "is always 'record'" do
          Record.new(Person).should be_a Record
        end
      end
      describe "#new" do
        context "when using the Person class" do
          subject { Record.new(Person, nil, enums: [{'Gender' => { }}]) }
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
            pets.should_not be_nil
          end
          it "doesn't remap known types as embedded types" do
            parent = subject.fields.find{ |f| f.name == 'parent' }
            parent.type.first.name.should == 'Person'
          end
          it "maps the pets relationship as an embedded type array" do
            pets = subject.fields.find{ |f| f.name == 'pets' }
            pets.type.should be_a ActiveAvro::Complex::Array
            pets.type.items.name.should == 'Pet'
          end
          it "should create the Gender enum field" do
            gender_attr = subject.fields.find{ |f| f.name == 'gender' }
            gender_attr.type.should be_a ActiveAvro::Complex::Enum
          end
        end

        describe "#to_hash" do
          subject { Record.new(Person).to_partial_schema }
          its([:name]){ should == 'Person' }
          its([:fields]) { should be_an ::Array }
        end
      end

    end
  end
end