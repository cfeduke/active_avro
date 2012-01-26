module ActiveAvro
  module Complex
    class Union < ::Array
      def to_partial_schema
        # this is not a hash, clearly going to have to rename these methods
        map{ |item| item.respond_to?(:to_partial_schema) ? item.to_partial_schema : item.to_s }
      end
    end
  end
end
