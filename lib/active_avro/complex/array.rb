module ActiveAvro
  module Complex
    class Array
      attr_accessor :items
      def initialize(record)
        @items = record
      end

      def to_hash
        items = @items.respond_to?(:to_hash) ? @items.to_hash : @items.to_s
        { :type => 'array', :items => items }
      end
    end
  end
end