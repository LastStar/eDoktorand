class Notifications < ActionMailer::Base
  def invite_candidate(candidate, faculty, sent_at = Time.now)
    @subject = I18n::t(:invite_candidate_to_exam, :scope => [:model, :notifications])
    @body['display_name'] = candidate.display_name
    @body['specialization'] = candidate.specialization.name
    @body['exam_term'] = candidate.specialization.exam_term
    @body['sent_on'] = sent_at
    @body['faculty'] = faculty
    @body['study_id'] = candidate.study_id
    @body['salutation'] = candidate.genderize(I18n::t(:dear_ms_mr, :scope => [:model, :notifications]), I18n::t(:dear_mr, :scope => [:model, :notifications]), I18n::t(:dear_ms, :scope => [:model, :notifications]))
    @recipients = candidate.email
    @cc        = faculty.secretary.email
    @from       = faculty.secretary.email
    @sent_on    = sent_at
  end

  # sends admit mail to candidate
  def admit_candidate(candidate, conditional, sent_at = Time.now)
    @subject = I18n::t(:notice_about_admitance, :scope => [:model, :notifications])
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
    @subject = I18n::t(:notice_about_admitance, :scope => [:model, :notifications])
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
  @subject = I18n.t(:study_plan_interruption_notice, :scope => [:model, :notifications])
    #@body['department_name'] = study_plan.index.department.name
    @body['first_name'] = study_plan.index.student.firstname
    @body['last_name'] = study_plan.index.student.lastname
    if study_plan.index.student.birth_number == nil
     @body['birth_number'] = ''
      else
       @body['birth_number'] = I18n.t(:with_personal_identfication_number, :scope => [:model, :notifications])  + study_plan.index.student.birth_number
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
    #@subject = t(:message_6, :scope => [:model, :notifications])
    @subject = I18n.t(:notice_about_study_plan, :scope => [:model, :notifications])
    @body['department_name'] = study_plan.index.department.name
    @body['first_name'] = study_plan.index.student.firstname
    @body['last_name'] = study_plan.index.student.lastname
    if study_plan.index.student.birth_number == nil
      @body['birth_number'] = ''
    else
      # @body['birth_number'] = I18n::t(:message_7, :scope => [:model, :notifications]) + study_plan.index.student.birth_number
      @body['birth_number'] = I18n.t(:with_personal_identfication_number, :scope => [:model, :notifications])  + study_plan.index.student.birth_number
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

  def created_account(im_identity, sent_at = Time.now)
    @subject = I18n::t(:account_created, :scope => [:model, :notifications])
    @body[:im_identity] = im_identity
    @from = "edoktorand@edoktorand.czu.cz"
    @recipients = im_identity.student.email
  end

  def claimed_final_exam(index, sent_at = Time.now)
    faculty = index.faculty
    @subject = I18n::t(:claimed_final_exam, :scope => [:model, :notifications])
    @body[:student] = index.student
    @body[:sent_on] = sent_at
    #TODO add to configuration
    @from = 'edoktorand@edoktorand.czu.cz'
    @recipients = faculty.secretary.email
    @cc = index.student.email
  end

  def invite_to_final_exam(index, sent_at = Time.now)
    faculty = index.faculty
    @subject = I18n::t(:final_exam_invitation, :scope => [:model, :notifications])
    @final_exam = index.final_exam_term
    @body[:student] = index.student.display_name_with_title
    @body[:chairman] = @final_exam.chairman.display_name
    @body[:sent_on] = sent_at
    @body[:room] = @final_exam.room
    @body[:date] = @final_exam.date
    @body[:start_time] = @final_exam.start_time
    @body[:id] = @final_exam.id
    @body['examinators'] = [
      @final_exam.first_examinator, @final_exam.second_examinator,
      @final_exam.third_examinator, @final_exam.fourth_examinator,
      @final_exam.fifth_examinator, @final_exam.sixth_examinator,
      @final_exam.seventh_examinator, @final_exam.eighth_examinator,
      @final_exam.nineth_examinator
    ].compact.reject(&:empty?)
    @body['opponents'] = [
      @final_exam.opponent, @final_exam.second_opponent,
      @final_exam.third_opponent
    ].compact.reject(&:empty?)
    @from = 'edoktorand@edoktorand.czu.cz'
    @recipients = [index.student.email, faculty.secretary.email]
    if @defense.chairman.email != nil
      @recipients << @defense.chairman.email
    end
  end

  def claimed_defense(index, sent_at = Time.now)
    faculty = index.faculty
    @subject = I18n::t(:claimed_defense, :scope => [:model, :notifications])
    @body[:student] = index.student
    @body[:sent_on] = sent_at
    #TODO add to configuration
    @from = 'edoktorand@edoktorand.czu.cz'
    @recipients = faculty.secretary.email
    @cc = index.student.email
  end

  def invite_to_defense(index, sent_at = Time.now)
    faculty = index.faculty
    @defense = index.defense
    @body[:student] = index.student.display_name_with_title
    @body[:chairman] = @defense.chairman.display_name
    @body[:sent_on] = sent_at
    @body[:room] = @defense.room
    @body[:date] = @defense.date
    @body[:start_time] = @defense.start_time
    @body[:id] = @defense.id
    @body['examinators'] = [
      @defense.first_examinator, @defense.second_examinator,
      @defense.third_examinator, @defense.fourth_examinator,
      @defense.fifth_examinator, @defense.sixth_examinator,
      @defense.seventh_examinator, @defense.eighth_examinator,
      @defense.nineth_examinator
    ].compact.reject(&:empty?)
    @body['opponents'] = [
      @defense.opponent, @defense.second_opponent,
      @defense.third_opponent
    ].compact.reject(&:empty?)
    @from = 'edoktorand@edoktorand.czu.cz'
    @recipients = [index.student.email, faculty.secretary.email]
    if @defense.chairman.email != nil
      @recipients << @defense.chairman.email
    end
  end

end
