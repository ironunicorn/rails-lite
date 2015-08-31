require_relative '../active_record/sql_object'
require_relative 'cat'
class Human < SQLObject
  self.finalize!
  has_many "cats"
end
