class Faculty < ActiveRecord::Base
  has_many :coridors
  has_many :departments
  has_many :documents
  has_one :deanship
  def self.for_select(options = {})
    result = self.find(:all).map {|f| [f.name, f.id]}
    if options[:include_empty]
      [['---', '0']].concat(result)
    else
      result
    end
  end
# returns string for sql IN statement
  def departments_for_sql
    self.departments.map {|dep| dep.id}.join(', ') 
  end
end
