# encoding: utf-8
class Notifications < ActionMailer::Base
  def invite_candidate(candidate, sent_at = Time.now)
    @subject = I18n::t(:message_0, :scope => [:txt, :model, :notifications])
    @display_name = candidate.display_name
    @address = candidate.address
    @specialization = candidate.specialization.name
    @exam_term = candidate.specialization.exam_term
    @sent_on = sent_at
    @faculty = candidate.specialization.admitting_faculty
    @study_id = candidate.study_id
    @salutation = candidate.genderize(I18n::t(:message_1, :scope => [:txt, :model, :notifications]), I18n::t(:message_2, :scope => [:txt, :model, :notifications]), I18n::t(:message_3, :scope => [:txt, :model, :notifications]))
    @recipients = candidate.email
    @cc = faculty.secretary.email.name
    @from = faculty.secretary.email.name
    @sent_on = sent_at
  end
  
  #sends admit mail to candidate
  def admit_candidate(candidate, conditional, sent_at = Time.now)
    @faculty = candidate.department.faculty
    @candidate = candidate
    @conditional = conditional
    @candidate = candidate
    @date = sent_at
    subject I18n::t(:message_4, :scope => [:txt, :model, :notifications])
    from @faculty.secretary.email.name
    cc @faculty.secretary.email.name
    recipients candidate.email
    sent_on sent_at
  end
  
  #sends reject mail to candidate
  def reject_candidate(candidate, sent_at = Time.now)
    @subject = I18n::t(:message_5, :scope => [:txt, :model, :notifications])
    @study = candidate.study.name
    @display_name = candidate.display_name
    @address = candidate.address
    @specialization = candidate.specialization.name
    @exam_term = candidate.specialization.exam_term
    @sent_on = sent_at
    @candidate = candidate
    @faculty = faculty = candidate.department.faculty
    @recipients = candidate.email
    @cc = faculty.secretary.email.name
    @from = faculty.secretary.email.name
    @sent_on = sent_at
  end

  def interrupt_alert(study_plan, interrupt, sent_at = Time.now)
    @subject = 'Vyrozumnění o přerušení studijního plánu'
    #@body['department_name'] = study_plan.index.department.name
    @first_name = study_plan.index.student.firstname
    @last_name = study_plan.index.student.lastname
    if study_plan.index.student.birth_number == nil
      @birth_number = ''
    else
      @birth_number = 's rodným číslem'  + study_plan.index.student.birth_number
    end
    @year = study_plan.index.year
    if interrupt.index.interrupted?
      @interrupted_on = interrupt.index.interrupted_on.strftime('%d. %m. %Y')
    elsif interrupt.index.admited_interrupt?
      @admited_interrupt_start = interrupt.index.interrupt.start_on.strftime('%m/%Y')
      @admited_interrupt_duration = interrupt.index.interrupt.duration
    else
      @last_interrupt = interrupt.start_on.strftime('%d. %m. %Y')
    end
    @tutor = study_plan.index.tutor.display_name
    @specialization = study_plan.index.specialization.name
    @sent_on = sent_at
    @note = interrupt.note
    @recipients = study_plan.index.faculty.secretary.email
    @from = 'edoktorand@edoktorand.czu.cz'
    @sent_on = sent_at
  end
  
  #send study plan of student
  def study_plan_create(study_plan, sent_at = Time.now)
    #@subject = t(:message_6, :scope => [:txt, :model, :notifications])
    @subject = 'Vyrozumnění o studijním plánu'
    @department_name = study_plan.index.department.name
    @first_name = study_plan.index.student.firstname
    @last_name = study_plan.index.student.lastname
    if study_plan.index.student.birth_number == nil
      @birth_number = ''
    else
      @birth_number = 's rodným číslem'  + study_plan.index.student.birth_number
    end
    @specialization = study_plan.index.specialization.name
    @sent_on = sent_at
    @recipients = study_plan.index.tutor.email
    @from = study_plan.index.faculty.secretary.email.name
    @sent_on = sent_at
  end

  def end_study(student, subject_end_study)
    @name = student.display_name
    @specialization = student.specialization.name
    @year = student.index.year
    @subject_end_study = subject_end_study
  end

  def change_tutor_en(student, subject_change_tutor)
    @name = student.display_name
    @specialization = student.specialization.name
    @year = student.index.year
    @subject_change_tutor = subject_change_tutor
  end
  
  def change_tutor_cs(student, subject_change_tutor)
    @name = student.display_name
    @specialization = student.specialization.name
    @year = student.index.year
    @subject_change_tutor = subject_change_tutor
  end

  def invite_to_final_exam(index, sent_at = Time.now)
    faculty = index.faculty
    @subject = I18n::t(:message_8, :scope => [:txt, :model, :notifications])
    @student = index.student
    @sent_on = sent_at
    if index.final_exam_term.chairman.email != nil
      @recipients = index.student.email.name, index.final_exam_term.chairman.email.name
    else
      @recipients = index.student.email.name
    end
    @cc = faculty.secretary.email.name
    @from = faculty.secretary.email.name
  end

  def invite_to_defense(index, sent_at = Time.now)
    faculty = index.faculty
    @subject = I18n::t(:message_9, :scope => [:txt, :model, :notifications])
    @student = index.student
    @sent_on = sent_at
    if index.defense.chairman.email != nil
      @recipients = index.student.email.name, index.defense.chairman.email.name
    else
      @recipients = index.student.email.name
    end
    @cc = faculty.secretary.email.name
    @from = faculty.secretary.email.name
  end

  def created_account(student, sent_at = Time.now)
    @subject = I18n::t(:message_10, :scope => [:txt, :model, :notifications])
    @student = student
    @from = "edoktorand@edoktorand.czu.cz"
    @recipients = student.email.name
  end
end
