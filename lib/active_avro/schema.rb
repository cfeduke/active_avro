module ActiveAvro
  class Schema < Hash
    attr_accessor :klass
    def initialize(klass)
      raise ArgumentError.new("klass must not be nil") if klass.nil?
      raise ArgumentError.new("klass must respond to columns") unless klass.respond_to? :columns
      raise ArgumentError.new("klass.columns must be an Array") unless klass.columns.is_a?(Array)
      @klass = klass
      map_schema
    end

    private
    def map_schema
      @klass.columns.map {|c| self[c.name] = c.type}
    end
  end
end