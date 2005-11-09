class Approvement < ActiveRecord::Base
  belongs_to :tutor_statement
  belongs_to :leader_statement
  belongs_to :dean_statement
  belongs_to :board_statement
  acts_as_audited
  # prepares approvement for object if it doesn't exists
  # returns statement for user
  def prepare_statement(user)
    if (self.tutor_statement || self.index.tutor == user.person) && !self.leader_statement && self.index.leader == user.person
      return LeaderStatement.new('person_id' => user.person.id)
    elsif !self.leader_statement && !self.tutor_statement && self.index.tutor == user.person 
      return TutorStatement.new('person_id' => user.person.id)
    elsif self.leader_statement && !self.dean_statement && user.person.is_dean_of?(self.index.student)
      return DeanStatement.new('person_id' => user.person.id)
    end
  end
  # returns if it have statement for user
  def prepares_statement?(user)
    if ((self.tutor_statement || self.index.tutor == user.person) &&
      !self.leader_statement && self.index.leader == user.person) || 
      (!self.leader_statement && !self.tutor_statement && self.index.tutor ==
      user.person) || (self.leader_statement && !self.dean_statement && 
      self.index.dean == user.person)
      return true
    end
  end
end
