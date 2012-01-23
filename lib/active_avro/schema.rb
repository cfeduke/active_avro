require 'active_avro/complex'
require 'json'

module ActiveAvro
  class Schema
    attr_accessor :record, :klass
    def initialize(klass)
      raise ArgumentError.new("klass must not be nil") if klass.nil?
      raise ArgumentError.new("klass must respond to columns") unless klass.respond_to? :columns
      raise ArgumentError.new("klass.columns must be an Array") unless klass.columns.is_a?(Array)
      @klass = klass
      @record = ActiveAvro::Complex::Record.new(@klass)
    end

    def to_json
      @record.to_hash.to_json
    end
  end
end