require 'tree'

module ActiveAvro
  module Complex
    # represents the Avro complex type record
    class Record
      attr_accessor :name, :fields
      attr_reader :node

      def initialize(klass, node = nil)
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
        if klass.respond_to?(:columns)
          @fields = klass.columns.map { |c| Field.from_column(c) }
        end
        if klass.respond_to?(:reflections)
          klass.reflections.each do |k,v|
            embedded_record = Record.as_embedded(v.klass, k.to_s, v.macro, self) rescue nil
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
        record = Record.new(klass, ancestor_record.node)
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
