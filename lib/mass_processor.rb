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
    nil
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

  def self.fix_bad_birt_numbers(students = nil)
    ActiveRecord::Base.connection.execute('SET NAMES UTF8')
    notfound = []
    students ||= Student.find(:all)
    @@mylog.info "There are %i students" % students.size
    students.each do |student|
      if c = Candidate.find(:all, :conditions => ["birth_number like ?",
                                                  "%s_" % student.birth_number])
        if c.size > 0
          if c.size > 1
            @@mylog.info "More than one candidate for student %i. Getting first." % student.id 
          end
          c = c.first
          @@mylog.info "Found one candidate for student %i" % student.id
          if c.birth_number =~ /\d{6}\//
            bn = c.birth_number.gsub(/\//, '')
            @@mylog.info "Got slash in birth number. Fixin student %i with %s" % [student.id, bn]
            student.update_attribute(:birth_number, bn)
          else
            @@mylog.info "No slash in birth number for %i" % student.id
          end
        else
          @@mylog.info "Candidate has't been found"
          notfound << student.id
        end
      end
    end
    return notfound
  end
end