require 'tree'

module ActiveAvro
  module Complex
    # represents the Avro complex type record
    class Record
      attr_accessor :name, :fields
      attr_reader :node
      attr_reader :filter

      def initialize(klass, node = nil, options = {})
        @name = klass.name
        @node = Tree::TreeNode.new((node.nil? ? klass.name : "#{node.name}\\#{klass.name}"), klass)
        if node.nil?
          node = @node
        else
          node << @node rescue return # when the klass has already been added at the present depth, don't add it again
        end

        if @node.node_depth > 0
          return if @node.parentage.any?{ |n| n.content == klass }
        end
        @fields = []
        @filter = options[:filter] || Filter.new
        if klass.respond_to?(:columns)
          klass.columns.each do |c|
            @fields << Field.from_column(c) unless @filter.exclude?(class: @name, attribute: c.name)
          end
        end
        if klass.respond_to?(:reflections)
          klass.reflections.each do |k,v|
            field_name = k.to_s
            next if @filter.exclude?(class: @name, attribute: field_name)
            embedded_record = Record.as_embedded(v.klass, field_name, v.macro, self) rescue nil
            @fields << embedded_record if (embedded_record)
          end
        end
      end
      def embedded?
        @embedded
      end
      def embedded=(value)
        @embedded = value
      end

      def self.as_embedded(klass, field_name, relationship, ancestor_record)
        record = Record.new(klass, ancestor_record.node, filter: ancestor_record.filter)
        record.embedded = true
        container =
            case relationship
              when :belongs_to || :has_one then ActiveAvro::Complex::NullUnion.new([record])
              when :has_many || :has_and_belongs_to_many then ActiveAvro::Complex::Array.new(record)
              else record
            end
        Field.new(field_name, container)
      end

      def fields
        @fields ||= []
      end

      def to_partial_schema
        # if there are no fields then just return the name - assume its already been embedded
        has_fields = @fields && @fields.length > 0
        return @name unless has_fields
        h = { :name => @name, :type => 'record' }
        if has_fields
          h[:fields] = @fields.map { |f| f.to_partial_schema }
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

        def to_partial_schema
          type =
              case
                when @type.is_a?(Symbol) then @type.to_s
                else @type.to_partial_schema
              end
          { :name => @name, :type => type }
        end
      end
    end
  end
end
