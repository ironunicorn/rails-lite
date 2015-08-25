module Searchable
  def where(params)
    results = DBConnection.execute(<<-SQL, params.values)
    	SELECT
    		*
    	FROM
    		#{table_name}
    	WHERE 
    		#{params.keys.join(' = ? AND ')} = ?
    SQL

    answer = []
    results.each do |result|
      answer << self.new(result)
    end

    answer
  end
end
