module ActiveAvro
  module Complex
    # represents the Avro complex type record
    class Record
      attr_accessor :name, :aliases, :namespace, :fields

      def initialize(klass)
        @name = klass.name

      end

      def type
        'record'
      end
      def aliases
        @aliases || []
      end
      def fields
        @fields || []
      end

      class Field
        attr_accessor :name, :type
        def initialize(name, type)
          @name, @type = name, type
        end

        def self.from_column(column)
          Field.new(column.name, TypeConverter.to_avro(column.type))
        end
      end
    end
  end
end
