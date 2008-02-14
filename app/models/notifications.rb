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
    @candidate = candidate
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
    @body['candidate'] = candidate
    @body[:faculty] = faculty = candidate.department.faculty
    @recipients = candidate.email
    @cc        = faculty.secretary.email.name
    @from       = faculty.secretary.email.name
    @sent_on = sent_at
  end

  def interupt_alert(study_plan, interupt, sent_at = Time.now)
  @subject = 'Vyrozumnění o přerušení studijního plánu'
    #@body['department_name'] = study_plan.index.department.name
    @body['first_name'] = study_plan.index.student.firstname
    @body['last_name'] = study_plan.index.student.lastname
    if study_plan.index.student.birth_number == nil
     @body['birth_number'] = ''
      else
       @body['birth_number'] = 's rodným číslem'  + study_plan.index.student.birth_number
    end
    @body['year'] = study_plan.index.year
    if interupt.index.interupted?
      @body['interupted_on'] = interupt.index.interupted_on.strftime('%d. %m. %Y')
    elsif interupt.index.admited_interupt?
      @body['admited_interrupt_start'] = interupt.index.interupt.start_on.strftime('%m/%Y')
      @body['admited_interrupt_duration'] = interupt.index.interupt.duration
    else
      @body['last_interrupt'] = interupt.start_on.strftime('%d. %m. %Y')
    end
    @body['tutor'] = study_plan.index.tutor.display_name
    @body['coridor'] = study_plan.index.coridor.name
    @body['sent_on'] = sent_at
    @body['note'] = interupt.note
    @recipients = study_plan.index.faculty.secretary.email
    @from = 'edoktorand@edoktorand.czu.cz'
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

  def end_study(student, subject_end_study)
    @body['name'] = student.display_name
    @body['coridor'] = student.coridor.name
    @body['year'] = student.index.year
    @body['subject_end_study'] = subject_end_study
  end

  def change_tutor(student, subject_change_tutor)
    @body['name'] = student.display_name
    @body['coridor'] = student.coridor.name
    @body['year'] = student.index.year
    @body['subject_change_tutor'] = subject_change_tutor
  end

  def invite_to_final_exam(index, sent_at = Time.now)
    faculty = index.faculty
    @subject = _("Invitation to final exam")
    @body[:student] = index.student
    @body[:sent_on] = sent_at
    @recipients = index.student.email
    @cc        = faculty.secretary.email.name
    @from       = faculty.secretary.email.name
  end

  def invite_to_defense(index, sent_at = Time.now)
    faculty = index.faculty
    @subject = _("Invitation to defense")
    @body[:student] = index.student
    @body[:sent_on] = sent_at
    @recipients = index.student.email
    @cc        = faculty.secretary.email.name
    @from       = faculty.secretary.email.name
  end

  def created_account(student, sent_at = Time.now)
    @subject = _("Created account")
    @body[:student] = student
    @from = "edoktorand@edoktorand.czu.cz"
    @recipients = student.email.name
  end
end
