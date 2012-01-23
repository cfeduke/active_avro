require 'bundler'
require 'rspec/core/rake_task'

Bundler::GemHelper.install_tasks

desc "Run specification tests"
RSpec::Core::RakeTask.new(:spec) do |rspec|
end
task :default => :spec

desc "Dump the Avro schema for an ActiveRecord::Base inheriting class to STDOUT"
task :dump, :model do |t, model|

end

desc "Open an pry session with ActiveAvro with prepared ActiveRecord models"
task :console do
  require 'pry'
  require 'interactive_editor'
  # uses the local .pryrc file
  Pry.start
end