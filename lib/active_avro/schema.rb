require 'active_avro/complex/record'
require 'active_avro/complex/union'
require 'active_avro/complex/null_union'

module ActiveAvro
  class Schema
    attr_accessor :record, :klass
    def initialize(klass)
      raise ArgumentError.new("klass must not be nil") if klass.nil?
      raise ArgumentError.new("klass must respond to columns") unless klass.respond_to? :columns
      raise ArgumentError.new("klass.columns must be an Array") unless klass.columns.is_a?(Array)
      @klass = klass
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
      defined = [@klass]
      @record = ActiveAvro::Complex::Record.new(@klass)

    end
  end
end