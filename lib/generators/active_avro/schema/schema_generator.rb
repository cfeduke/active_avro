require 'active_avro'

module ActiveAvro
  module Generators
    class SchemaGenerator < Rails::Generators::NamedBase
      argument :name, :type => :string
      class_option :human_readable, :type => :boolean, :default => true, :alias => '-h', :desc => 'Outputs Avro schema file in human readable JSON (instead of compact)'
      class_option :console, :type => :boolean, :default => true, :alias => '-c', :desc => 'Output to STDOUT instead of file.'

      IGNORE_FILTER_PATH = 'config/active_avro_ignore_filter.yml'
      ENUM_PATH = 'config/active_avro_enums.yml'

      def execute
        aa_opts = ActiveAvro::Options.new(IGNORE_FILTER_PATH, ENUM_PATH)
        aa_opts.messages.each { |msg| console_message msg }
        s = ActiveAvro::Schema.new(name.constantize, aa_opts.to_hash)

        str_json = s.to_json
        if options[:human_readable]
          begin
            json = JSON.parse(str_json)
            str_json = JSON.pretty_unparse(json)
          rescue
            console_message "Error: #{$!}"
          end
        end
        if options[:console]
          puts str_json
        end
      end

      private
      def console_message(msg)
        puts msg unless options[:quiet]
      end
    end
  end
end