require 'spec_helper'

module ActiveAvro
  describe Schema do
    it "verifies that the person model exists" do
      p = Person.new(:name => 'Charles')
      p.name.should == 'Charles'
    end
  end
end