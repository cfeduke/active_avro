require 'spec_helper'

module ActiveAvro
  describe Schema do
    describe "#new" do
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
        Schema.new(Person).type.should == Person
      end
      context "when reflecting upon Person's schema'" do
        subject { Schema.new(Person) }
        it "maps the name" do
          subject['name'].type.should == :string
        end
        it "maps a relationship" do
          subject['pets'].type.should == Pet
        end
      end


    end

    describe "#" do

    end
  end
end