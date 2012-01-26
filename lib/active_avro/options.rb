module ActiveAvro
  require 'active_avro/filter'
  require 'yaml'

  class Options
    attr_reader :messages, :filter, :enums
    def initialize(ignore_filter_path, enum_path)
      @messages = []
      # try to read ignore filter
      @filter = nil
      if File.exists? ignore_filter_path
        begin
          @filter = ActiveAvro::Filter.from_yaml(File.open(ignore_filter_path))
        rescue
          messages << %Q{Warning: unable to load #{ignore_filter_path} due to #{$!}}
        end
      else
        @filter = ActiveAvro::Filter.new
        messages << %Q{Warning: no "#{ignore_filter_path}" file, all attributes will be reflected in the schema.}
      end
      @enums = []
      if File.exists? enum_path
        begin
          enums_data = YAML::load(File.open(enum_path))
          # Model: { options }
          enums_data.each do |e|
            @enums << { e.first => e.second }
          end
        rescue
          console_message %Q{Warning: unable to load #{enum_path} due to #{$!}}
          @enums = [] # reset, just in case
        end
      end
    end

    def to_hash
      { :filter => @filter, :enums => @enums }
    end
  end
end