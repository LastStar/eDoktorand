class Notifications < ActionMailer::Base
  def invite_candidate(candidate, faculty, sent_at = Time.now)
    @subject = I18n::t(:invite_candidate_to_exam, :scope => [:txt, :model, :notifications])
    @body['display_name'] = candidate.display_name
    @body['specialization'] = candidate.specialization.name
    @body['exam_term'] = candidate.specialization.exam_term
    @body['sent_on'] = sent_at
    @body['faculty'] = faculty
    @body['study_id'] = candidate.study_id
    @body['salutation'] = candidate.genderize(I18n::t(:dear_ms_mr, :scope => [:txt, :model, :notifications]), I18n::t(:dear_mr, :scope => [:txt, :model, :notifications]), I18n::t(:dear_ms, :scope => [:txt, :model, :notifications]))
    @recipients = candidate.email
    @cc        = faculty.secretary.email
    @from       = faculty.secretary.email
    @sent_on    = sent_at
  end

  # sends admit mail to candidate
  def admit_candidate(candidate, conditional, sent_at = Time.now)
    @subject = I18n::t(:notice_about_admitance, :scope => [:txt, :model, :notifications])
    @body[:candidate] = candidate
    @body[:faculty] = faculty = candidate.department.faculty
    @body[:sent_on] = sent_at
    @body[:conditional] = conditional
    @candidate = candidate
    @recipients = candidate.email
    @cc = faculty.secretary.email
    @from = faculty.secretary.email
  end

  #sends reject mail to candidate
  def reject_candidate(candidate, sent_at = Time.now)
    @subject = I18n::t(:notice_about_admitance, :scope => [:txt, :model, :notifications])
    @body['study'] = candidate.study.name
    @body['display_name'] = candidate.display_name
    @body['specialization'] = candidate.specialization.name
    @body['exam_term'] = candidate.specialization.exam_term
    @body['sent_on'] = sent_at
    @body['candidate'] = candidate
    @body[:faculty] = faculty = candidate.department.faculty
    @recipients = candidate.email
    @cc        = faculty.secretary.email
    @from       = faculty.secretary.email
    @sent_on = sent_at
  end

  def interrupt_alert(study_plan, interrupt, sent_at = Time.now)
  @subject = I18n.t(:study_plan_interruption_notice, :scope => [:txt, :model, :notifications])
    #@body['department_name'] = study_plan.index.department.name
    @body['first_name'] = study_plan.index.student.firstname
    @body['last_name'] = study_plan.index.student.lastname
    if study_plan.index.student.birth_number == nil
     @body['birth_number'] = ''
      else
       @body['birth_number'] = I18n.t(:with_personal_identfication_number, :scope => [:txt, :model, :notifications])  + study_plan.index.student.birth_number
    end
    @body['year'] = study_plan.index.year
    if interrupt.index.interrupted?
      @body['interrupted_on'] = interrupt.index.interrupted_on.strftime('%d. %m. %Y')
    elsif interrupt.index.admited_interrupt?
      @body['admited_interrupt_start'] = interrupt.index.interrupt.start_on.strftime('%m/%Y')
      @body['admited_interrupt_duration'] = interrupt.index.interrupt.duration
    else
      @body['last_interrupt'] = interrupt.start_on.strftime('%d. %m. %Y')
    end
    @body['tutor'] = study_plan.index.tutor.display_name
    @body['specialization'] = study_plan.index.specialization.name
    @body['sent_on'] = sent_at
    @body['note'] = interrupt.note
    @recipients = study_plan.index.faculty.secretary.email
    @from = 'edoktorand@edoktorand.czu.cz'
    @sent_on = sent_at
  end

  #send study plan of student
  def study_plan_create(study_plan, sent_at = Time.now)
    #@subject = t(:message_6, :scope => [:txt, :model, :notifications])
    @subject = I18n.t(:notice_about_study_plan, :scope => [:txt, :model, :notifications])
    @body['department_name'] = study_plan.index.department.name
    @body['first_name'] = study_plan.index.student.firstname
    @body['last_name'] = study_plan.index.student.lastname
    if study_plan.index.student.birth_number == nil
     @body['birth_number'] = ''
      else
       # @body['birth_number'] = I18n::t(:message_7, :scope => [:txt, :model, :notifications]) + study_plan.index.student.birth_number
       @body['birth_number'] = I18n.t(:with_personal_identfication_number, :scope => [:txt, :model, :notifications])  + study_plan.index.student.birth_number
    end
    @body['specialization'] = study_plan.index.specialization.name
    @body['sent_on'] = sent_at
    @recipients = study_plan.index.tutor.email
    @from = study_plan.index.faculty.secretary.email
    @sent_on = sent_at
  end

  def end_study(student, subject_end_study)
    @body['name'] = student.display_name
    @body['specialization'] = student.specialization.name
    @body['year'] = student.index.year
    @body['subject_end_study'] = subject_end_study
  end

  def change_tutor_en(student, subject_change_tutor)
    @body['name'] = student.display_name
    @body['specialization'] = student.specialization.name
    @body['year'] = student.index.year
    @body['subject_change_tutor'] = subject_change_tutor
  end

  def change_tutor_cs(student, subject_change_tutor)
    @body['name'] = student.display_name
    @body['specialization'] = student.specialization.name
    @body['year'] = student.index.year
    @body['subject_change_tutor'] = subject_change_tutor
  end

  def invite_to_final_exam(index, sent_at = Time.now)
    faculty = index.faculty
    @subject = I18n::t(:final_exam_invitation, :scope => [:txt, :model, :notifications])
    @body[:student] = index.student
    @body[:sent_on] = sent_at
    if index.final_exam_term.chairman.email != nil
      @recipients = index.student.email, index.final_exam_term.chairman.email
    else
      @recipients = index.student.email
    end
    @cc        = faculty.secretary.email
    @from       = faculty.secretary.email
  end

  def invite_to_defense(index, sent_at = Time.now)
    faculty = index.faculty
    @subject = I18n::t(:defense_invitation, :scope => [:txt, :model, :notifications])
    @body[:student] = index.student
    @body[:sent_on] = sent_at
    if index.defense.chairman.email != nil
      @recipients = index.student.email, index.defense.chairman.email
    else
      @recipients = index.student.email
    end
    @cc        = faculty.secretary.email
    @from       = faculty.secretary.email
  end

  def created_account(im_identity, sent_at = Time.now)
    @subject = I18n::t(:account_created, :scope => [:txt, :model, :notifications])
    @body[:im_identity] = im_identity
    @from = "edoktorand@edoktorand.czu.cz"
    @recipients = im_identity.student.email
  end
end
