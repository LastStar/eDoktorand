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
    @body['salutation'] = candidate.genderize(_("Dear  Mr./Mrs."),_("Dear Mr."),_("Dear Mrs."))
    @recipients = candidate.email
    @cc        = faculty.secretary.email.name
    @from       = faculty.secretary.email.name
    @sent_on    = sent_at
  end
  
  #sends admit mail to candidate
  def admit_candidate(candidate, conditional, sent_at = Time.now)
    @subject = _("Notification about admition procedure to postgradula study")
    @body[:candidate] = candidate
    @body[:faculty] = faculty = candidate.department.faculty
    @body[:sent_on] = sent_at
    @body[:conditional] = conditional
    @recipients = candidate.email
    @cc        = faculty.secretary.email.name
    @from       = faculty.secretary.email.name
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
  
  #send study plan of student
  def study_plan_create(study_plan, sent_at = Time.now)
  #@subject = _("notification of study plan")
  @subject = 'Vyrozumnění o studijním plánu'
  @body['department_name'] = study_plan.index.department.name
  @body['first_name'] = study_plan.index.student.firstname
  @body['last_name'] = study_plan.index.student.lastname
  if study_plan.index.student.birth_number == nil
   @body['birth_number'] = ''
    else
     # @body['birth_number'] = _("with birth number ") + study_plan.index.student.birth_number
     @body['birth_number'] = 's rodným číslem'  + study_plan.index.student.birth_number
  end
  @body['coridor'] = study_plan.index.coridor.name
  @body['sent_on'] = sent_at
  @recipients = study_plan.index.tutor.email
  @from = study_plan.index.faculty.secretary.email.name
  @sent_on = sent_at
  end
end
