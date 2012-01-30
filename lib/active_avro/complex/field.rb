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
              # this needs to become more configurable
              when @type.is_a?(Symbol) then NullUnion.new([@type.to_s])
              else @type.to_partial_schema
            end
        { :name => @name, :type => type }
      end

      def cast(instance)
        sym = @name.to_sym
        if instance.nil?
          return { sym => nil }
        end
        attr = instance.send(sym)
        if attr.nil?
          return { sym => nil }
        end
        attr = @type.cast(attr) if @type.respond_to?(:cast)
        #puts "@type.respond_to?(:cast): #{@name}\##{@type.class.name}: #{@type.respond_to?(:cast)}"
        attr = TypeConverter.convert(attr)
        { sym => attr }
      end
    end
  end
end