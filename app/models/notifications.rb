class Notifications < ActionMailer::Base
  def invite_candidate(candidate, faculty, sent_at = Time.now)
    @subject = 'Pozvanka na prijimaci zkousky na doktorske studium'
    @body['display_name'] = candidate.display_name
    @body['address'] = candidate.address
    @body['coridor'] = candidate.coridor.name
    @body['exam_term'] = candidate.coridor.exam_term
    @body['sent_on'] = sent_at
    @body['faculty'] = faculty
    @recipients = candidate.email
    @from       = 'pepe@pef.czu.cz'
    @sent_on    = sent_at
  end
  #sends admit mail to candidate
  def admit_candidate(candidate, sent_at = Time.now)
    @subject = 'Vyrozumeni o prijimacim rizeni na doktorske studium'
    @body['study'] = candidate.study.name
    @body['display_name'] = candidate.display_name
    @body['address'] = candidate.address
    @body['coridor'] = candidate.coridor.name
    @body['exam_term'] = candidate.coridor.exam_term
    @body['tutor'] = candidate.tutor.display_name
    @body['department'] = candidate.department.name
    @body['sent_on'] = sent_at
    @recipients = candidate.email
    @from = 'pepe@gravastar.cz'
    @sent_on = sent_at
  end
  #sends reject mail to candidate
  def reject_candidate(candidate, sent_at = Time.now)
    @subject = 'Vyrozumeni o prijimacim rizeni na doktorske studium'
    @body['study'] = candidate.study.name
    @body['display_name'] = candidate.display_name
    @body['address'] = candidate.address
    @body['coridor'] = candidate.coridor.name
    @body['exam_term'] = candidate.coridor.exam_term
    @body['sent_on'] = sent_at
    @recipients = candidate.email
    @from = 'pepe@gravastar.cz'
    @sent_on = sent_at
  end
end
