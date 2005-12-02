class Approvement < ActiveRecord::Base
  belongs_to :tutor_statement
  belongs_to :leader_statement
  belongs_to :dean_statement
  belongs_to :board_statement
  acts_as_audited
  # prepares approvement for object if it doesn't exists
  # returns statement for user
  def prepare_statement(user)
    if (tutor_statement || index.tutor == user.person) && !leader_statement && index.leader == user.person
      return LeaderStatement.new('person_id' => user.person.id)
    elsif !leader_statement && !tutor_statement && index.tutor == user.person 
      return TutorStatement.new('person_id' => user.person.id)
    elsif leader_statement && !dean_statement && user.person.is_dean_of?(index.student)
      return DeanStatement.new('person_id' => user.person.id)
    end
  end
  # returns if it have statement for user
  def prepares_statement?(user)
    if ((tutor_statement || index.tutor == user.person) &&
      !leader_statement && index.leader == user.person) || 
      (!leader_statement && !tutor_statement && index.tutor ==
      user.person) || (leader_statement && !dean_statement &&
      user.person.is_dean_of?(index.student))
      return true
    end
  end
end
