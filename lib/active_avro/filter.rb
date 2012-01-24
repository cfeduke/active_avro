module ActiveAvro
  # used to filter away attributes from an ActiveRecord model so they aren't serialized as
  # part of the object graph
  class Filter < Hash
    def initialize()
      self.default_proc = Proc.new {|h,k| h[k] = []}
    end
    def exclude?(options = {})
      false if empty? # shortcut
      key = options[:class].to_s || '*'
      value = options[:attribute] || '*'
      is_match = Proc.new { |e| (e =~ value) != nil }
      binding.pry if key == 'Person' && value == 'parent_id'
      self[key].empty? || self[key].any?{|e| is_match.call(e)} || (key != '*' && self['*'].any?{|e| is_match.call(e)})
    end
    # the format is 'class#attribute'
    # the attribute can be a regular expression string
    # use * as a wildcard for class names, i.e. '*#created_by' to nix all created_by attributes
    # specify only the class name to ignore any attributes that are instances of that class
    # 'class#*' is the same as specifying only the class name
    def self.build(filter_expressions = [])
      f = Filter.new
      filter_expressions.each do |fe|
        e = Entry.parse(fe)
        f[e.class_name] << e.attribute
      end
      ## for any keys that contain a wildcard, clobber the array
      keys = []
      f.each { |k,v| keys << k if v.include? '*' }
      keys.each { |k| f[k] = [] }
      f
    end

    class Entry
      attr_reader :class_name, :attribute
      def initialize(class_name, attribute)
        @class_name, @attribute = class_name, attribute
      end
      def self.parse(str)
        class_name, attr = str.split('#')
        if attr.nil? || attr == '*'
          attr = '*'
        else
          attr = Regexp.new(attr)
        end
        Entry.new(class_name, attr)
      end
    end
  end
end