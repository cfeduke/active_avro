module ActiveAvro
  module Complex
    class NullUnion < Union
      attr_accessor :type
      def initialize(*args)
        super(*args)
        self << 'null'
      end
      def type
        NullUnion
      end
    end
  end
end
