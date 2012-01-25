module ActiveAvro
  module Complex
    class Union < ::Array
      def to_hash
        # this is not a hash, clearly going to have to rename these methods
        map{ |item| item.respond_to?(:to_hash) ? item.to_hash : item.to_s }
      end
    end
  end
end
