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

CreatePeople.up