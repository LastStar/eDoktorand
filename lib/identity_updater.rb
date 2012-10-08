require 'log4r'
module Identity
  class Updater
    IDENTITY_URL = "http://10.70.1.11:18888/"

    # initializes client and dates
    def initialize(url = IDENTITY_URL)
      @mylog = Log4r::Logger.new 'IdentityUpdater'
      @mylog.outputters = Log4r::Outputter.stdout
      return self
    end

    # updates identity management tresor with updated students
    def update_students
      Student.all.each do |student|
          [student.id, student.display_name]
        begin
          student.update_im_student
        rescue => ex
          @mylog.error 'There was an error: %s updating student #%s' % [ex.message, student.id]
        end
        @mylog.info 'Students updated!'
      end
    end

    # updates identity management tresor with updated indices
    def update_indices
      Index.all.each do |index|
        begin
          index.update_im_index
        rescue => ex
          @mylog.error 'There was an error: %s updating index #%i' % [ex.message, index.id]
        else
          @mylog.info 'Index updated!'
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
end
