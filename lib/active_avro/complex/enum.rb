module ActiveAvro
  module Complex
    class Enum
      DEFAULT_ZERO_NAME = 'Unknown'
      DEFAULT_VALUE_ATTRIBUTE_NAME = 'id'
      DEFAULT_NAME_ATTRIBUTE_NAME = 'name'
      attr_reader :zero_name, :value_attribute_name, :name_attribute_name, :klass,
        :values, :options
      def initialize(klass, options = {})
        @options = options || {}
        @zero_name = @options[:zero_name] || DEFAULT_ZERO_NAME
        @value_attribute_name = @options[:value_attribute_name] || DEFAULT_VALUE_ATTRIBUTE_NAME
        @name_attribute_name = @options[:name_attribute_name] || DEFAULT_NAME_ATTRIBUTE_NAME
        @klass = klass
        get_values
      end
      def name
        @klass.nil? ? 'nil' : @klass.name
      end
      def get_values
        # TODO throw an error if the name isn't a valid Avro identifier
        if @klass.nil? || !(@klass.respond_to? :order)
          @values = []
          return @values
        end
        all = @klass.order(@value_attribute_name)
        val_sym = @value_attribute_name.to_sym
        name_sym = @name_attribute_name.to_sym
        @values = all.map{|e| { :value => e.send(val_sym), :name => e.send(name_sym) } }
        @values.insert(0, { :value => 0, :name => @zero_name }) unless @values.first[:value] == 0
        @values
      end

      def to_partial_schema
        h = { :type => 'enum', :name => @klass.name }
        h[:namespace] = @options[:namespace] if @options[:namespace]
        h[:symbols] = @values.map { |v| v[:name] }
        h
      end

      def cast(instance)
        # TODO throw an error if the name isn't a valid Avro identifier
        return @zero_name if instance.nil?
        result = instance.send @name_attribute_name.to_sym
        result = @zero_name if result.nil?
        result
      end
    end
  end
end