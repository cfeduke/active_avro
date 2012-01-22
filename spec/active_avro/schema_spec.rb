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
        Schema.new(Person).klass.should == Person
      end
    end

    describe "#" do

    end
  end
end