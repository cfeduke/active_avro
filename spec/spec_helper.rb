require 'rspec'
require 'active_record'
require 'helpers/active_avro_helper'

# derived from https://github.com/ernie/squeel/blob/master/spec/spec_helper.rb
RSpec.configure do |config|
  config
  config.before(:suite) do
    puts '=' * 80
    puts "Running specs against ActiveRecord #{ActiveRecord::VERSION::STRING}"
    puts '=' * 80
    ActiveAvroHelper.initialize
  end
end

require 'active_avro'