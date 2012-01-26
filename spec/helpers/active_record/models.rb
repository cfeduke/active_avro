class Person < ActiveRecord::Base
  has_many :pets, :foreign_key => 'owner_id'
  #has_many :children, :class_name => 'Person', :foreign_key => 'id'
  # asexual reproduction!
  belongs_to :parent, :class_name => 'Person', :foreign_key => 'parent_id'
  belongs_to :gender
end
class Pet < ActiveRecord::Base
  belongs_to :owner, :class_name => 'Person', :foreign_key => :owner_id
end
class Choice < ActiveRecord::Base

end
class Gender < ActiveRecord::Base

end
class Dma < ActiveRecord::Base

end