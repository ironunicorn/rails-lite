require_relative './db_connection'
require_relative './associatable'
require 'active_support/inflector'


class SQLObject
  extend Searchable
  extend Associatable

  def self.columns
    names = DBConnection.execute2(<<-SQL)
      SELECT
        #{table_name}.*
      FROM
        #{table_name}
    SQL

    names.first.map { |name| name.to_sym }
  end

  def self.finalize!
    self.columns.each do |column|
      define_method(column.to_s) { attributes[column] }

      define_method("#{column}=") do |value|
        attributes[column] = value
      end
    end
  end

  def self.table_name=(table_name)
    instance_variable_set("@table_name", table_name)
  end

  def self.table_name
    @table_name ||= self.inspect.tableize
    instance_variable_get("@table_name")
  end

  def self.all
    results = DBConnection.execute(<<-SQL)
      SELECT
        #{table_name}.*
      FROM
        #{table_name}
    SQL

    parse_all(results)
  end

  def self.parse_all(results)
    answer = []
    results.each do |result|
      answer << self.new(result)
    end

    answer
  end

  def self.find(id)
    result = DBConnection.execute(<<-SQL, id)
      SELECT
        #{table_name}.*
      FROM
        #{table_name}
      WHERE
        id = ?
    SQL

    return nil if result.empty?
    self.new(result.first)
  end

  def initialize(params = {})
    params.each do |name, attr_value|
      attr_name = name.to_sym
      unless self.class.columns.include?(attr_name)
        raise "unknown attribute '#{attr_name}'"
      end
      send("#{attr_name}=", attr_value)
    end
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    @attributes.values
  end

  def insert
    DBConnection.execute(<<-SQL, *attribute_values)
      INSERT INTO
        #{self.class.table_name} (#{self.class.columns.drop(1).join(', ')})
      VALUES
        (#{(['?'] * attribute_values.length).join(', ')})
    SQL

    self.id = DBConnection.last_insert_row_id
  end

  def update
    DBConnection.execute(<<-SQL, *(attribute_values.rotate))
      UPDATE
        #{self.class.table_name}
      SET
        #{self.class.columns.drop(1).join(' = ?, ')} = ?
      WHERE
        id = ?
    SQL
  end

  def save
    id.nil? ? insert : update
  end
end
