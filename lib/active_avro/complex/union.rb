module ActiveAvro
  module Complex
    class Union < ::Array
      def to_partial_schema
        map{ |item| item.respond_to?(:to_partial_schema) ? item.to_partial_schema : item.to_s }
      end

      def cast(instance)
        type = find { |t| t.respond_to?(:cast) && t.respond_to?(:klass) && instance.is_a?(t.klass) }
        # if there's no type then its a primitive
        return instance unless type
        type.cast(instance)
      end
    end
  end
end
