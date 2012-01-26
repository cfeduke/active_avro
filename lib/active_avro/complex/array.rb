module ActiveAvro
  module Complex
    class Array
      attr_accessor :items
      def initialize(record)
        @items = record
      end

      def to_partial_schema
        items = @items.respond_to?(:to_partial_schema) ? @items.to_partial_schema : @items.to_s
        { :type => 'array', :items => items }
      end
    end
  end
end