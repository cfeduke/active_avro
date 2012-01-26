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
          subject { Record.new(Person, nil, enums: [{ :name => 'Gender' }]) }
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
            gender = subject.fields.find{ |f| f.name == 'gender' }
            gender.should be_a ActiveAvro::Complex::Enum
          end
        end

        describe "#to_hash" do
          subject { Record.new(Person).to_partial_schema }
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
          subject { Record::Field.new('xyz', TypeConverter.to_avro(:integer)).to_partial_schema }
          its([:name]) { should == 'xyz' }
          context "when type is a symbol" do
            its([:type]) { should == TypeConverter.to_avro(:integer).to_s }
          end
          context "when type is a record" do
            subject { Record::Field.new('xyz', Record.new(Pet)).to_partial_schema }
            its([:type]){ should be_a Hash }
          end
          context "when type is an enum" do
            subject { Record::Field.new('gender', Enum.new(Gender)).to_partial_schema }
            its([:type]){ should be_a Hash }
            its([:name]){ should == 'gender' }
            it "should have the expected enumerated values" do
              e = subject[:type]
              e[:type].should == 'enum'
              e[:name].should == 'Gender'
              e[:symbols].should == %w((All) Male Female)
            end
          end
        end
      end

    end
  end
end