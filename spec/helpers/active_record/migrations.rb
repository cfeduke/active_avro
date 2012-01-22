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

CreatePets.up
CreatePeople.up