require File.dirname(__FILE__) + '/../test_helper'

class CandidateTest < Test::Unit::TestCase
  fixtures :candidates

  def setup
    @candidate = Candidate.new
    @candidate_from_db = Candidate.find(1)
  end
  def test_validation
    assert !@candidate.valid?
    @candidate.firstname = 'Curik'
    @candidate.lastname = 'Murik'
    @candidate.coridor_id = '3'
    @candidate.birth_at = 'Okurikov'
    @candidate.email = 'curik@muriky.cv'
    @candidate.street = 'Curikova'
    @candidate.city = 'Murikovo'
    @candidate.zip = '45454'
    @candidate.state = 'Czeccc'
    @candidate.university = 'Uniii'
    @candidate.faculty = '5'
    @candidate.studied_branch = 'Nejakej'
    @candidate.birth_number = '4545664333'
    @candidate.number = '12'
    @candidate.language1 = '1'
    @candidate.language2 = '2'
    assert @candidate.valid?
    @candidate.email = 'curik$muriky.cv'
    assert !@candidate.valid?
    @candidate.email = 'curik@muriky.cv'
    assert @candidate.valid?
    @candidate.birth_number = '454566433' # same as in fixtures
    assert !@candidate.valid?
  end
  def test_timestamps
    @candidate_from_db.finish!
    assert @candidate_from_db.finished_on < Time.now
    @candidate_from_db.admit!
    assert !@candidate_from_db.valid?
    @candidate_from_db.invite!
    assert @candidate_from_db.valid?
    @candidate_from_db.invited_on = nil
    @candidate_from_db.enroll!
    assert !@candidate_from_db.valid?
    @candidate_from_db.invite!
    assert @candidate_from_db.student
  end
  def test_enroll
    @candidate_from_db.finish!
    @candidate_from_db.invite!
    @candidate_from_db.admit!
    assert !@candidate_from_db.student
    @candidate_from_db.enroll!
    student = @candidate_from_db.student
    assert student.display_name == @candidate_from_db.display_name
    assert student.email.name == @candidate_from_db.email
    assert student.address.street == @candidate_from_db.street
    assert student.postal_address.street == @candidate_from_db.postal_street
    assert student.phone.name == @candidate_from_db.phone
  end
end
