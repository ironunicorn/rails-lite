require_relative '../active_record/sql_object'
require_relative 'human'
class Cat < SQLObject
  self.finalize!
  belongs_to "human"
end
