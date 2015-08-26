require_relative '../active_record/sql_object'
class Cat < SQLObject
  self.finalize!
end
