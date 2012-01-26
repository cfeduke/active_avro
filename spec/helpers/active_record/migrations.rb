class CreateYesNo < ActiveRecord::Migration
  def self.up
    create_table :choices do |t|
      t.string :name
    end
  end
  def self.down
    drop_table :yes_no
  end
end
class CreateGender < ActiveRecord::Migration
  def self.up
    create_table :genders do |t|
      t.string :name
    end
  end
  def self.down
    drop_table :gender
  end
end
class CreateDma < ActiveRecord::Migration
  def self.up
    create_table :dmas do |t|
      t.integer :dma_id
      t.string :zip_code
    end
  end
  def self.down
    drop_table :dmas
  end
end
class CreatePets < ActiveRecord::Migration
  def self.up
    create_table :pets do |t|
      t.string :name
      t.string :species
      t.integer :owner_id
      t.timestamps
    end
  end
  def self.down
    drop_table :pets
  end
end
class CreatePeople < ActiveRecord::Migration
  def self.up
    create_table :people do |t|
      t.string :name
      t.date :date_of_birth
      t.integer :parent_id
      t.timestamps
    end
  end
  def self.down
    drop_table :people
  end
end

CreateYesNo.up
CreateGender.up
CreateDma.up
CreatePets.up
CreatePeople.up

# seeds.rb
require_relative 'models'

Choice.create!([{name:'Yes'},{name:'No'}])
Gender.create!([{name:'Male'},{name:'Female'},{name:'(All)'}])
ActiveRecord::Base.connection.execute(%Q{UPDATE "genders" SET "id" = 0 WHERE "genders"."name" = '(All)'})
# no these are not actual values
Dma.create!([{dma_id: 300, zip_code: '13905'}, {dma_id: 301, zip_code: '22407'}])