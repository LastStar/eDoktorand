require 'log4r'
class MassProcessor
  include Log4r

  @@mylog = Logger.new 'Importer'
  @@mylog.outputters = Outputter.stdout
  @@mylog.level = 1

  # approve all indexes 
  def self.mass_approve(indices)
    @@mylog.info "There are #{indices.size} indices"
    indices.each do |i|
      if i.study_plan
        app = i.study_plan.approvement || StudyPlanApprovement.new
        created = app.created_on = i.study_plan.approved_on = \
          i.enrolled_on + 1.month
        app.tutor_statement ||= TutorStatement.create('person_id' => i.tutor_id, 
          'result' => 1, 'note' => '', 'created_on' => created)
        app.leader_statement ||= LeaderStatement.create('person_id' => i.leader.id, 
          'result' => 1, 'note' => '', 'created_on' => created)
        app.dean_statement ||= DeanStatement.create('person_id' => i.dean.id, 
          'result' => 1, 'note' => 'approved by machine', 'created_on' => created)
        i.study_plan.approve!
        app.save
        i.save
      else
        @@mylog.debug "Index #{i.id} does not have study plan"
      end
    end
  end

  def self.clean_coridor_subjects
    @count = 0
    Faculty.find(:all).each do |f|
      f.coridors.each do |c|
        @last = nil
        c.obligate_subjects.each {|cs| change_last_or_delete(cs)}
        c.voluntary_subjects.each {|cs| change_last_or_delete(cs)}
        c.language_subjects.each {|cs| change_last_or_delete(cs)}
        c.requisite_subjects.each {|cs| change_last_or_delete(cs)}
        c.seminar_subjects.each {|cs| change_last_or_delete(cs)}
      end
    end
    @@mylog.debug "count" + @count.to_s
  end

  def self.change_last_or_delete(vs)
    if @last == vs.subject_id
      @@mylog.debug "To delete #{vs.type} id: " + vs.id.to_s
      vs.destroy
      @count += 1
    else
      @last = vs.subject_id
    end
  end
end
