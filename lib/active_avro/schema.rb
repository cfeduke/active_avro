require 'active_avro/complex'
require 'json'
require 'active_avro/filter'

module ActiveAvro
  class Schema
    attr_accessor :record, :klass, :structure
    def initialize(klass, options = { })
      raise ArgumentError.new("klass must not be nil") if klass.nil?
      raise ArgumentError.new("klass must respond to columns") unless klass.respond_to? :columns
      raise ArgumentError.new("klass.columns must be an Array") unless klass.columns.is_a?(Array)
      @klass = klass

      @record = ActiveAvro::Complex::Record.new(@klass, nil, options)
    end

    def structure
      @structure ||= @record.to_partial_schema
    end

    def to_json
      self.structure.to_json
    end

    # converts the instance to a hash representative of the schema
    def cast(instance)
      raise ArgumentError.new("instance must not be nil") if instance.nil?
      raise ArgumentError.new("instance must be an instance of #{@klass.name}") unless instance.is_a? @klass
      @record.cast(instance)
    end
  end
end