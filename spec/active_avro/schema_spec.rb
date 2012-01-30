require 'spec_helper'

module ActiveAvro
  describe Schema do
    describe "#initialize" do
      it "raises an error when klass is nil" do
        ->{Schema.new(nil)}.should raise_error(::ArgumentError)
      end
      it "raises an error when klass doesn't respond_to? columns" do
        class Foo; end
        ->{Schema.new(Foo)}.should raise_error(::ArgumentError)
      end
      it "raises an error when klass.columns is not an array" do
        class Foo
          def self.columns
            !nil
          end
        end
        ->{Schema.new(Foo)}.should raise_error(::ArgumentError)
      end
      it "assigns klass to the passed parameter" do
        Schema.new(Person).klass.should == Person
      end
    end

    describe "#cast" do
      it "should raise an error when the instance to convert is not the class the schema represents" do
        ->{Schema.new(Person).cast(Pet.new)}.should raise_error(::ArgumentError)
      end
      it "should raise an error when the instance to convert is nil" do
        ->{Schema.new(Person).cast(nil)}.should raise_error(::ArgumentError)
      end

      context "when some fields are ignored" do
        let(:filter) { Filter.build(%W(Pet#name Person#name)) }
        let(:schema) { Schema.new(Person, filter: filter) }
        let(:person) { Person.find_by_name 'Charles' }
        subject { schema.cast(person) }
        it "should not include the ignored Pet#name field" do
          subject['pets'].first.should_not have_key 'name'
        end
        it "should not include the ignored Person#name (specifically parent) field" do
          subject['parent'].should be_a Hash
          subject['parent'].should_not have_key 'name'
        end
      end
    end

  end
end