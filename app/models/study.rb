class Study < ActiveRecord::Base
  has_many :canditats
# returns array structured for html select
  def self.for_select(options = {})
    result = find(:all).map {|s| [s.name, s.id]}
    if options[:include_empty]
      [['---', '0']].concat(result)
    else
      result
    end
  end

end
