module ActiveAvroHelper
  require 'active_record'
  require 'sqlite3'

  # code derived from http://7fff.com/2010/12/02/activerecord-dropcreate-database-run-migrations-outside-of-rails/
  SQLITE_SPEC = {
      :adapter => 'sqlite3',
      :database => ':memory:'
  }
  def ActiveAvroHelper.initialize_database
    ActiveRecord::Base.establish_connection(SQLITE_SPEC)

    # create schema by executing migrations
    CreatePerson.up
  end

  class CreatePerson < ActiveRecord::Migration
    def self.up
      create_table :person do |t|
        t.string :name
        t.date :date_of_birth
        t.timestamps
      end
    end
    def self.down
      drop_table :person
    end
  end
end