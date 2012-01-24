require 'spec_helper'

module ActiveAvro
  describe Filter do
    describe 'self#build' do
      subject { Filter.build(['Person#created_at', 'Person#updated_at', 'Pet', '*#.*_id', 'Blah#*']) }
      it "should only have two elements for the 'Person' key" do
        subject['Person'].length.should == 2
      end
      its(['Person']){ should include /created_at/ }
      its(['Person']){ should include /updated_at/ }
      its(['*']){ should include /.*_id/ }
      its(['Pet']){ should be_empty }
    end

    describe 'Filter::Entry' do
      describe 'self#parse' do
        context "when the string to parse is in class#attribute format" do
          subject { Filter::Entry.parse('class#attribute') }
          its('class_name') { should == 'class' }
          its('attribute') { should be_a Regexp }
        end
        context "when the string to parse is in class only format" do
          subject { Filter::Entry.parse('class') }
          its('class_name') { should == 'class' }
          its('attribute') { should == '*' }
        end
      end
    end
  end
end