module ActiveAvro
  module Complex
    # represents the Avro complex type record
    class Record
      attr_accessor :name, :fields

      def initialize(klass, root_klass = nil)
        @name = klass.name
        return if root_klass == klass
        root_klass = klass if root_klass.nil?
        @fields = klass.columns.map { |c| Field.from_column(c) }
        klass.reflections.each do |k,v|
          @fields << Record.as_embedded(v.klass, k.to_s, v.macro, root_klass)
        end
      end
      def embedded?
        @embedded
      end
      def embedded=(value)
        @embedded = value
      end

      def self.as_embedded(klass, field_name, relationship, root_klass)
        record = Record.new(klass, root_klass)
        record.embedded = true
        container =
            case relationship
              when :belongs_to || :has_one then ActiveAvro::Complex::NullUnion.new([record])
              when :has_many || :has_and_belongs_to_many then ActiveAvro::Complex::Array.new(record)
              else record
            end
        Field.new(field_name, container)
      end

      def type
        'record'
      end
      def fields
        @fields ||= []
      end

      def to_hash
        # if there are no fields then just return the name - assume its already been embedded
        has_fields = @fields && @fields.length > 0
        return @name unless has_fields
        h = { :name => @name, :type => type }
        if has_fields
          h[:fields] = @fields.map { |f| f.to_hash }
        end
        h
      end

      class Field
        attr_accessor :name, :type
        def initialize(name, type)
          @name, @type = name, type
        end

        def self.from_column(column)
          Field.new(column.name, TypeConverter.to_avro(column.type))
        end

        def to_hash
          type =
              case
                when @type.is_a?(Symbol) then @type.to_s
                else @type.to_hash
              end
          { :name => @name, :type => type }
        end
      end
    end
  end
end
