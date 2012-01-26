module ActiveAvro
  module Complex
    class Enum
      DEFAULT_ZERO_NAME = 'Unknown'
      DEFAULT_VALUE_ATTRIBUTE_NAME = 'id'
      DEFAULT_NAME_ATTRIBUTE_NAME = 'name'
      attr_reader :zero_name, :value_attribute_name, :name_attribute_name, :klass,
        :values
      def initialize(klass, options = {})
        @zero_name = options[:zero_name] || DEFAULT_ZERO_NAME
        @value_attribute_name = options[:value_attribute_name] || DEFAULT_VALUE_ATTRIBUTE_NAME
        @name_attribute_name = options[:name_attribute_name] || DEFAULT_NAME_ATTRIBUTE_NAME
        @klass = klass
      end
      def get_values
        all = @klass.order(@value_attribute_name)
        val_sym = @value_attribute_name.to_sym
        name_sym = @name_attribute_name.to_sym
        @values = all.map{|e| { :value => e.send(val_sym), :name => e.send(name_sym) } }
        @values.insert(0, { :value => 0, :name => @zero_name }) unless @values.first[:value] == 0
        @values
      end
    end
  end
end