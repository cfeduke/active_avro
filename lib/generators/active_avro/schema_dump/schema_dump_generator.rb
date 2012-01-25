require 'active_avro'
module ActiveAvro
  module Generators
    class SchemaDumpGenerator < Rails::Generators::NamedBase
      argument :name, :type => :string
      def execute
        # try to read ./config/active_avro_ignore_filter.yml

        s = ActiveAvro::Schema.new(name.constantize)
        puts s.to_json
      end
    end
  end
end