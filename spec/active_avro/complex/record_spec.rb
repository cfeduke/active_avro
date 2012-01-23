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
            pets.should_not be_nil
          end
          it "doesn't remap known types as embedded types" do
            parent = subject.fields.find{ |f| f.name == 'parent' }
            parent.type.type.should == NullUnion
            parent.type.first.name.should == 'Person'
          end
          it "maps the pets relationship as an embedded type array" do
            pets = subject.fields.find{ |f| f.name == 'pets' }
            pets.type.type.should == ActiveAvro::Complex::Array
            pets.type.items.name.should == 'Pet'
          end
        end

        describe "#to_hash" do
          subject { Record.new(Person).to_hash }
          its([:type]){ should == 'record' }
          its([:name]){ should == 'Person' }
          its([:fields]) { should be_an ::Array }
        end
      end

      describe Record::Field do
        describe "self#from_column" do
          subject { Record::Field.from_column(Person.columns.find { |c| c.name == 'name' }) }
          its("name") { should == 'name' }
          its("type") { should == :string }
        end
        describe "#to_hash" do
          subject { Record::Field.new('xyz', TypeConverter.to_avro(:integer)).to_hash }
          its([:name]) { should == 'xyz' }
          context "when type is a symbol" do
            its([:type]) { should == TypeConverter.to_avro(:integer).to_s }
          end
          context "when type is a record" do
            subject { Record::Field.new('xyz', Record.new(Pet)).to_hash }
            it "should return a hash for :type" do
              pending
              # TODO fix this; right now Pet->owner->Person->parent->Person... needs to be handled
            end
          end
        end
      end

    end
  end
end