module ActiveAvroHelper
  require 'active_record'
  require 'sqlite3'

  # code derived from http://7fff.com/2010/12/02/activerecord-dropcreate-database-run-migrations-outside-of-rails/
  SQLITE_SPEC = {
      :adapter => 'sqlite3',
      :database => ':memory:'
  }
  def ActiveAvroHelper.initialize
    ActiveRecord::Base.establish_connection(SQLITE_SPEC)

    # create schema by executing migrations
    CreatePeople.up

    # include the models
    require 'helpers/models/person'
  end

  class CreatePeople < ActiveRecord::Migration
    def self.up
      create_table :people do |t|
        t.string :name
        t.date :date_of_birth
        t.timestamps
      end
    end
    def self.down
      drop_table :people
    end
  end
end