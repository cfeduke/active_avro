require 'active_avro'

module ActiveAvro
  module Generators
    class SchemaDumpGenerator < Rails::Generators::NamedBase
      argument :name, :type => :string

      IGNORE_FILTER_PATH = 'config/active_avro_ignore_filter.yml'

      def execute
        # try to read ignore filter
        filter = nil
        if File.exists? IGNORE_FILTER_PATH
          begin
            filter = ActiveAvro::Filter.from_yaml(File.open(IGNORE_FILTER_PATH))
          rescue
            puts %Q{Warning: unable to YAML::load #{IGNORE_FILTER_PATH} due to a problem.}
          end
        else
          filter = ActiveAvro::Filter.new
          puts %Q{Warning: no "#{IGNORE_FILTER_PATH}" file, all attributes will be reflected in the schema.}
        end

        s = ActiveAvro::Schema.new(name.constantize, filter: filter)
        puts s.to_json
      end
    end
  end
end