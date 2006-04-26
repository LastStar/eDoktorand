class Notifications < ActionMailer::Base
  def invite_candidate(candidate, faculty, sent_at = Time.now)
    @subject = _("Invitation to admition tests to postgradual study")
    @body['display_name'] = candidate.display_name
    @body['address'] = candidate.address
    @body['coridor'] = candidate.coridor.name
    @body['exam_term'] = candidate.coridor.exam_term
    @body['sent_on'] = sent_at
    @body['faculty'] = faculty
    @body['study_id'] = candidate.study_id
    @recipients = candidate.email
    @from       = 'pepe@pef.czu.cz'
    @sent_on    = sent_at
  end
  #sends admit mail to candidate
  def admit_candidate(candidate, sent_at = Time.now)
    @subject = _("Notification about admition procedure to postgradula study")
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
    @subject = _("Notification about admition procedure to postgradula study")
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
