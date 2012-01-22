module ActiveAvro
  module TypeConverter
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
  end
end