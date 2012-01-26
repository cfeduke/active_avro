module ActiveAvro
  module Complex
    class Enum
      DEFAULT_ZERO_NAME = 'Unknown'
      DEFAULT_VALUE_ATTRIBUTE_NAME = 'id'
      DEFAULT_NAME_ATTRIBUTE_NAME = 'name'
      attr_reader :zero_name, :value_attribute_name, :name_attribute_name
      def initialize(options = {})
        @zero_name = options[:zero_name] || DEFAULT_ZERO_NAME
        @value_attribute_name = options[:value_attribute_name] || DEFAULT_VALUE_ATTRIBUTE_NAME
        @name_attribute_name = options[:name_attribute_name] || DEFAULT_NAME_ATTRIBUTE_NAME
      end
    end
  end
end