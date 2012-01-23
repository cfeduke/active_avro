module ActiveAvro
  module Complex
    class Union < ::Array
      attr_accessor :type
      def type
        Union
      end

      def to_hash
        # this is not a hash, clearly going to have to rename these methods
        map{ |item| item.respond_to?(:to_hash) ? item.to_hash : item.to_s }
      end
    end
  end
end
