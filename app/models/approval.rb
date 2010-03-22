class Approval < ActiveRecord::Base
  
  belongs_to :tutor_statement
  belongs_to :leader_statement
  belongs_to :dean_statement
  belongs_to :board_statement
  acts_as_audited

  # prepares approval for object if it doesn't exists
  # returns statement for user
  def prepare_statement(user)
    if user.has_role?('faculty_secretary') && (index.faculty == user.person.faculty)
      return build_dean_statement('person_id' => user.person.id)
    end
    if (tutor_statement || index.tutor == user.person) && !leader_statement &&
      user.person.is_leader_of?(index)
      return build_leader_statement('person_id' => user.person.id)
    elsif !leader_statement && !tutor_statement && index.tutor == user.person 
      return build_tutor_statement('person_id' => user.person.id)
    elsif leader_statement && !dean_statement && user.person.is_dean_of?(index)
      return build_dean_statement('person_id' => user.person.id)
    end
  end

  # returns if it have statement for user
  def prepares_statement?(user)
    if dean_statement
      false
    elsif user.has_role? 'faculty_secretary'
      true
    elsif ((tutor_statement || index.tutor == user.person) &&
      !leader_statement && index.leader == user.person) || 
      (!leader_statement && !tutor_statement && index.tutor ==
      user.person) || (leader_statement && !dean_statement &&
      user.person.is_dean_of?(index))
      true
    end
  end

  def approved_by
    t(:message_0, :scope => [:txt, :model, last_approver.to_s.underscore])
  end

  def last_approver
    if dean_statement
      Dean
    elsif leader_statement
      Leader
    elsif tutor_statement
      Tutor
    end
  end
end
