class Exam < ActiveRecord::Base
  belongs_to :index
  belongs_to :subject
  belongs_to :created_by, :class_name => "Person", :foreign_key => "created_by_id"
  belongs_to :first_examinator, :class_name => "Person", :foreign_key => "first_examinator_id"
  belongs_to :second_examinator, :class_name => "Person", :foreign_key => "second_examinator_id"
  validates_presence_of :index
  validates_presence_of :subject
  # returns true if result is pass
  def passed?
   return true if result == 1
  end

  # returns all exams for user
  def self.find_for(user)
    if user.has_role?('tutor') 
      sql = ['first_examinator_id = ?', @user.person.id]
    else
      sub_ids = Subject.find_for(user).map {|s| s.id}
      sql = ["subject_id IN (?)", sub_ids]
    end
    find(:all, :conditions => sql, :order => 'created_on desc')
  end
  
end
