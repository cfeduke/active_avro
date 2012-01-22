class Person < ActiveRecord::Base
  has_many :pets
  has_many :children, :class_name => 'Person'
  # asexual reproduction!
  belongs_to :parent, :class_name => 'Person', :foreign_key => 'parent_id'
end
class Pet < ActiveRecord::Base
  belongs_to :person, :foreign_key => :owner_id
end