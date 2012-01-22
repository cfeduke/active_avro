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

    # execute migrations
    require 'helpers/active_record/migrations'

    # include the models
    require 'helpers/active_record/models'
  end


end