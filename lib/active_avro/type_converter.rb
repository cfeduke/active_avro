module ActiveAvro
  module TypeConverter
    @@registered_converters = { }
    PRIMITIVES = {
        :primary_key => :int, # this is possibly incorrect
        :string => :string,
        :text => :string,
        :integer => :int,
        :float => :float,
        :decimal => :double,
        :datetime => :long,
        :timestamp => :long,
        :time => :long,
        :date => :long,
        :binary => :bytes,
        :boolean => :boolean
    }
    # converts an ActiveRecord column type to an Avro compatible type
    def TypeConverter.to_avro(sym)
      PRIMITIVES[sym]
    end

    # register a proc for the conversion of type values
    def TypeConverter.register(ruby_type, proc)
      @@registered_converters[ruby_type] = proc
    end

    def TypeConverter.is_registered?(ruby_type)
      @@registered_converters.has_key? ruby_type
    end

    # clears the type conversion registrations and then re-registers the default converters
    def TypeConverter.reset_registrations
      @@registered_converters.clear
      TypeConverter.register_default_converters
    end

    def TypeConverter.convert(value)
      return TypeConverter.is_registered?(value.class) ? @@registered_converters[value.class].call(value) : value
    end

    def TypeConverter.register_default_converters
      # Avro doesn't support date/time or time types so we convert those to
      # milliseconds since epoch by default
      TypeConverter.register(Time, Proc.new { |t| t.to_i * 1_000 })
    end

    TypeConverter.register_default_converters
  end
end