module ActiveAvro
  module Complex
    # represents the Avro complex type record
    class Record
      attr_accessor :name, :fields

      def initialize(klass, initialized = [])
        @name = klass.name
        return if initialized.include? klass
        initialized << klass
        @fields = klass.columns.map { |c| Field.from_column(c) }
        klass.reflections.each do |k,v|
          @fields << Record.as_embedded(v.klass, k.to_s, initialized)
        end
      end
      def embedded?
        @embedded
      end
      def embedded=(value)
        @embedded = value
      end

      def self.as_embedded(klass, field_name, initialized)
        record = Record.new(klass, initialized)
        record.embedded = true
        Field.new(field_name, record)
      end

      def type
        'record'
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
