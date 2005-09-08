class Approvement < ActiveRecord::Base
  # prepares approvement for object if it doesn't exists
  # returns statement for user
  def prepare_statement(person)
    if (self.tutor_statement || self.index.tutor == person) && !self.leader_statement && self.index.leader == person
      return LeaderStatement.new('person_id' => person.id)
    elsif !self.leader_statement && !self.tutor_statement && self.index.tutor == person 
      return TutorStatement.new('person_id' => person.id)
    elsif self.leader_statement && !self.dean_statement && self.index.dean == person
      return DeanStatement.new('person_id' => person.id)
    end
  end
  belongs_to :tutor_statement
  belongs_to :leader_statement
  belongs_to :dean_statement
  belongs_to :board_statement
  acts_as_audited
end
