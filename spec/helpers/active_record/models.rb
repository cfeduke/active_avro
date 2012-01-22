class Person < ActiveRecord::Base
  has_many :pets
end
class Pet < ActiveRecord::Base
  belongs_to :person, :foreign_key => :owner_id
end