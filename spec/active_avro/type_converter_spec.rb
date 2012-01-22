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
  end
end