require 'active_avro'
module ActiveAvro
  module Generators
    class SchemaDumpGenerator < Rails::Generators::NamedBase
      argument :name, :type => :string
      def execute
        s = ActiveAvro::Schema.new(name.constantize)
        puts s.to_json
      end
    end
  end
end