class Parameter < ActiveRecord::Base

  belongs_to :faculty

  validates_presence_of :name
  validates_presence_of :value

  serialize :value

  # get parameter
  def self.get(name, faculty)
    param = find_by_name_and_faculty_id(name, faculty.id)
    return param.value if param
  end

end
