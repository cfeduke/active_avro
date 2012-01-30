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
      end

      describe "#to_partial_schema" do
        subject { Record.new(Person).to_partial_schema }
        its([:name]){ should == 'Person' }
        its([:fields]) { should be_an ::Array }
      end

      describe "#cast" do
        context "when the instance is nil" do
          subject { Record.new(Person).cast(nil) }
          it { should be_nil }
        end
        context "when the instance is legal" do
          let(:charles) { Person.find_by_name('Charles') }
          subject { Record.new(Person).cast(charles) }
          it { should_not be_nil }
          its(['name']){ should == 'Charles' }
          its(['pets']){ should_not be_empty }
          its(['pets']){ subject.first.should be_a Hash }
          its(['pets']){ subject.first['name'].should == 'Shreen' }
          its(['pets']){ subject.second['name'].should == 'Sobek' }
          it "should use the built in TypeConverter for Time instances" do
            expected = charles.created_at.to_i * 1_000
            subject['created_at'].should == expected
          end
        end
        context "when the instance has a null enum value" do
          let(:person) { Person.new(:name => 'Lauren', :gender => nil) }
          subject { Record.new(Person, nil, enums: [{'Gender' => { }}]).cast(person) }
          its(['gender']) { should_not be_nil }
        end
      end
    end

  end
end