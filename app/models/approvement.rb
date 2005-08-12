class Approvement < ActiveRecord::Base
  belongs_to :tutor_statement
  belongs_to :leader_statement
  belongs_to :dean_statement
  belongs_to :board_statement
  # prepares approvement for object if it doesn't exists
  # returns statement for user
  def prepare_statement(person)
    if person.is_a?(Tutor) &&
      !self.tutor_statement
      return TutorStatement.new('person_id' => person.id)
    elsif person.is_a?(Leader) &&
      !self.leader_statement
      return LeaderStatement.new('person_id' => person.id)
    elsif person.is_a?(Dean) &&
      !self.dean_statement
      return DeanStatement.new('person_id' => person.id)
    end
  end
end
