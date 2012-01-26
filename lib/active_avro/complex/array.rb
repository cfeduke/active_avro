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

      def cast(instance)
        result = nil
        if @items.respond_to?(:cast)
          if instance.respond_to?(:map)
            result = instance.map { |i| @items.cast(i) }
          else
            result = [@items.cast(instance)]
          end
        else
          result = instance.is_a?(::Array) ? instance : [instance]
        end
        result
      end
    end
  end
end