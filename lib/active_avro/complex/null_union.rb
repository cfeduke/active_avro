module ActiveAvro
  module Complex
    class NullUnion < Union
      def initialize(*args)
        super(*args)
        self << 'null'
      end
    end
  end
end
