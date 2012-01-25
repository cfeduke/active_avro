require 'spec_helper'

module ActiveAvro
  describe Filter do
    subject { Filter.build(['Person#created_at', 'Person#updated_at', 'Pet', '*#.*_id$', 'Blah#*']) }
    describe 'self#build' do
      it "should only have two elements for the 'Person' key" do
        subject['Person'].length.should == 2
      end
      its(['Person']){ should include /created_at/ }
      its(['Person']){ should include /updated_at/ }
      its(['*']){ should include /.*_id$/ }
      its(['Pet']){ should be_empty }
      its(['Blah']){ should be_empty }
    end

    describe '#exclude?' do
      it "should exclude class 'Blah'" do
        subject.exclude?(:class => 'Blah').should be_true
      end
      it "should exclude class 'Pet'" do
        subject.exclude?(:class => 'Pet').should be_true
      end
      it "should include class 'Person'" do
        subject.exclude?(:class => 'Person').should be_false
      end
      it "should exclude any attribute ending in '_id'" do
        subject.exclude?(:attribute => 'parent_id').should be_true
      end
      it "should exclude 'Person#created_at'" do
        subject.exclude?(:class => 'Person', :attribute => 'created_at')
      end
      it "should not exclude 'Person#id'" do
        subject.exclude?(:class => 'Person', :attribute => 'id')
      end
      it "should exclude 'Person#parent_id' due to '*#.*_id$'" do
        subject.exclude?(class: 'Person', attribute: 'parent_id').should be_true
      end
    end

    describe "#self#from_yaml" do
      subject { Filter.from_yaml(<<-YAML
Person:
 - created_at
 - updated_at
'*':
  - !ruby/regexp '/.*_id$/'
Owner:
YAML
) }
      its(['Person']) { should include /created_at/ }
      its(['Person']) { should include /updated_at/ }
      its(['*']) { should include /.*_id$/ }
      its(['Owner']) { should_not be_nil }
      its(['Owner']) { should be_empty }
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