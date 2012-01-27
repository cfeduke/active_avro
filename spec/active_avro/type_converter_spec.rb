require 'spec_helper'
module ActiveAvro
  describe "TypeConverter" do
    describe "#convert" do
      it "converts ActiveRecord types into Avro primitive types" do
        f = Proc.new { |s| TypeConverter.to_avro(s) }
        f.call(:primary_key).should == :int
        f.call(:string).should == :string
        f.call(:text).should == :string
        f.call(:integer).should == :int
        f.call(:float).should == :float
        f.call(:decimal).should == :double
        f.call(:datetime).should == :long
        f.call(:timestamp).should == :long
        f.call(:time).should == :long
        f.call(:date).should == :long
        f.call(:binary).should == :bytes
        f.call(:boolean).should == :boolean
      end
    end

    describe "#is_registered? and #register" do
      context "when no types are registered" do
        subject { TypeConverter.is_registered?(String) }
        it { should be_false }
      end
      context "when a type is registered" do
        before { TypeConverter.register(String, Proc.new {|t| t}) }
        after { TypeConverter.reset_registrations }
        subject { TypeConverter.is_registered?(String) }
        it { should be_true }
      end
    end

    describe "#convert" do
      context "when no types are registered" do
        subject { TypeConverter.convert(12) }
        it { should == 12 }
      end
      context "when a converter is registered" do
        before { TypeConverter.register(Fixnum, Proc.new { |i| i * 2 }) }
        after { TypeConverter.reset_registrations }
        subject { TypeConverter.convert(12) }
        it { should == 24 }
      end
    end

    describe "#reset_registrations" do
      context "when registering String and then resetting" do
        before do
          TypeConverter.register(String, Proc.new{ |s| s })
          TypeConverter.reset_registrations
        end
        it "should have Time as a registered converter" do
          TypeConverter.is_registered?(Time).should be_true
        end
        it "should not have String as a registered converter" do
          TypeConverter.is_registered?(String).should be_false
        end
      end
    end

    describe "#self" do
      context "when initialized" do
        it "should have Time as a registered converter" do
          TypeConverter.is_registered?(Time).should be_true
        end
        describe "Time converter" do
          it "should convert time to the expected milliseconds since epoch value" do
            t = Time.parse('2012-01-27 10:56:17')
            TypeConverter.convert(t).should == 1327679777000
          end
        end
      end
    end
  end
end