require 'log4r'
class IdentityUpdater
  IDENTITY_URL = "http://10.70.1.11:18888/"

  # initializes client and dates
  def initialize(url = IDENTITY_URL)
    @mylog = Log4r::Logger.new 'IdentityUpdater'
    @mylog.outputters = Log4r::Outputter.stdout
    @mylog.level = 1
    @client = ActionWebService::Client::Soap.new(StudentApi, url)
    @start = Date.yesterday.beginning_of_day
    @finish = Date.yesterday.end_of_day
    return self
  end

  # updates identity management tresor with updated students
  def update_students(students = [])
    if students.empty?
      students = Student.find(:all,
        :conditions => ["updated_on > ? and updated_on < ?", @start, @finish])
    end
    students.each do |student|
      @mylog.debug 'Trying to update student #%i of %s' %
        [student.id, student.display_name]
      begin
        @client.update_student_with_uic(student.to_service_struct)
      rescue => ex
        @mylog.error 'There was an error: %s updating student #%s' % [ex.message, student.id]
      else
        @mylog.info 'Updated!'
      end
    end
  end

  # updates identity management tresor with updated indices
  def update_indices(indices = [])
    if indices.empty?
      indices = Index.find(:all,
        :conditions => ["updated_on > ? and updated_on < ?", @start, @finish])
    end
    indices.each do |index|
      @mylog.debug 'Trying to update index #%i' % index.id
      begin
        @client.update_index_with_student_uic(index.to_service_struct)
      rescue => ex
        @mylog.error 'There was an error: %s updating index #%i' % [ex.message, index.id]
      else
        @mylog.info 'Updated!'
      end
    end
  end

  # class methods
  class << self
    # creates new updater and update both models
    def update_all_models
      updater = self.new
      updater.update_students
      updater.update_indices
    end
  end
end
