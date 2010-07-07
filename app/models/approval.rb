class Approval < ActiveRecord::Base
  
  belongs_to :tutor_statement
  belongs_to :leader_statement
  belongs_to :dean_statement
  belongs_to :board_statement

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
    elsif leader_statement && !dean_statement && user.person.dean_of?(index)
      return build_dean_statement('person_id' => user.person.id)
    end
  end

  # returns if it have statement for person
  def prepares_statement?(person)
    if dean_statement
      false
    elsif person.is_a? FacultySecretary
      true
    elsif waiting_for_tutor_statement?(person) || 
      waiting_for_leader_statement?(person) || 
      waiting_for_dean_statement?(person)
      true
    end
  end

  #TODO vvv get rid of these vvv
  def approved_by
    t(:message_0, :scope => [:txt, :model, last_approver.to_s.underscore])
  end

  def waiting_for_tutor_statement?(person)
   !leader_statement && !tutor_statement && index.tutor == person 
  end

  def waiting_for_leader_statement?(person)
   ((tutor_statement || index.tutor == person) &&
      !leader_statement && index.leader == person) 
  end

  def waiting_for_dean_statement?(person)
    leader_statement && !dean_statement && person.dean_of?(index)
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

  # returns last approvement
  def last_statement
    if dean_statement
      dean_statement
    elsif leader_statement
      leader_statement
    elsif tutor_statement
      tutor_statement
    end
  end
end
