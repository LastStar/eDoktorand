require 'identity_updater'
class CandidateEnroller
  # creates new enroller
  def initialize
    @mylog = Log4r::Logger.new 'IdentityUpdater'
    @mylog.outputters = Log4r::Outputter.stdout
    @mylog.level = 1
  end

  # enrolls candidates, get uic for them and update identity in tresor
  def enroll(candidates)
    # returns array of students created from candidates
    @mylog.info "Enrolling candidates"
    students = candidates.map do |candidate|
      candidate.enroll!
    end
    indices = students.map(&:index)
    @mylog.info "Getting uic"
    getter = UicGetter.new
    getter.update_uic(students)
    updater = IdentityUpdater.new
    @mylog.info "Updating students"
    updater.update_students(students)
    @mylog.info "Updating indices"
    updater.update_indices(indices)
  end
end
