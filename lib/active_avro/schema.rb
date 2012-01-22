require 'active_avro/complex/record'

module ActiveAvro
  class Schema < Hash
    attr_accessor :type
    def initialize(klass)
      raise ArgumentError.new("klass must not be nil") if klass.nil?
      raise ArgumentError.new("klass must respond to columns") unless klass.respond_to? :columns
      raise ArgumentError.new("klass.columns must be an Array") unless klass.columns.is_a?(Array)
      @type = klass
      map_schema
    end

    private
    def self.recursive_initialize(klass, already_defined)
      if already_defined.include?(klass)
        nil
      else
        already_defined << klass
        Schema.new(klass)
      end
    end
    def map_schema
      defined = [@type]
      @type.columns.each { |c| self[c.name] = c }
      @type.reflections.each do |k,v|
        # don't map :belongs_to back to its parent
        unless v.macro == :belongs_to
          self[k.to_s] = Schema.recursive_initialize(v.klass, defined)
        end
      end
    end
  end
end