def _pry_before_session
  dir = File.dirname(__FILE__)
  %w(lib spec test).map{ |d| "#{dir}/#{d}" }.each { |p| $: << p unless !Dir.exists?(p) || $:.include?(p) }
  require 'active_avro'
  require 'spec_helper'
  ActiveAvroHelper.initialize
end

