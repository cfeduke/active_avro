require 'yaml'

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
        e = fe.is_a?(ActiveAvro::Filter::Entry) ? fe : Entry.parse(fe)
        f[e.class_name] << e.attribute
      end
      f.compact!
      f
    end

    # for any keys that contain a wildcard, clobber the array
    def compact!
      keys = []
      self.each { |k, v| keys << k if v.include? '*' }
      keys.each { |k| self[k] = [] }
    end

    # to specify a class as a wildcard you cannot use unescaped * in YAML
    # instead you have to enclose it in quotes or ticks, i.e. '*'
    def self.from_yaml(yaml)
      filter_expressions = []
      hash = YAML::load(yaml)
      hash.keys.each do |k|
        v = hash[k]
        if v.nil?
          filter_expressions << Entry.new(k, nil)
          next
        end
        v.each do |e|
          filter_expressions << Entry.new(k, e)
        end
      end
      filter_expressions.each {|fe| puts fe}
      Filter.build(filter_expressions)
    end

    class Entry
      attr_reader :class_name, :attribute
      def initialize(class_name, attribute)
        @class_name = class_name
        self.attribute = attribute
      end
      def self.parse(str)
        class_name, attr = str.split('#')
        Entry.new(class_name, attr)
      end
      def to_s
        "#{@class_name}\##{@attribute.to_s}"
      end
      private
      def attribute=(value)
        @attribute = value.nil? || value == '*' ? '*' : Regexp.new(value)
      end
    end
  end
end