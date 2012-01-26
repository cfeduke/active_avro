module ActiveAvro
  module Complex
    class Field
      attr_accessor :name, :type
      def initialize(name, type)
        @name, @type = name, type
      end

      def self.from_column(column)
        Field.new(column.name, TypeConverter.to_avro(column.type))
      end

      def to_partial_schema
        type =
            case
              when @type.is_a?(Symbol) then @type.to_s
              else @type.to_partial_schema
            end
        { :name => @name, :type => type }
      end

      def cast(instance)
        sym = @name.to_sym
        attr = instance.send(sym)
        attr = @type.cast(attr) if @type.respond_to?(:cast)
        { sym => attr }
      end
    end
  end
end