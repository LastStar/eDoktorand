class Notifications < ActionMailer::Base
  def invite_candidate(candidate, sent_at = Time.now)
    @subject = 'Pozvanka na prijimaci zkousky na doktorske studium'
    @body['display_name'] = candidate.display_name
    @body['address'] = candidate.address
    @body['coridor'] = candidate.coridor.name
    @body['exam_term'] = candidate.coridor.exam_term
    @body['sent_on'] = sent_at
    @recipients = candidate.email
    @from       = 'pepe@pef.czu.cz'
    @sent_on    = sent_at
  end
  def admit_candidate(candidate, sent_at = Time.now)
    @subject = 'Vyrozumění o příjimacím řízení na doktorské studium'
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
end
