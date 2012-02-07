module ServiceTools
  module Subjects
    # repairs all subjects from subjects service
    # based on response from GetSubjectService
    def self.repair_all(response)
      response.each do |subjectHash|
        subject = Subject.find_by_code(subjectHash[:code]) || Subject.new(:code => subjectHash[:code])
        subject.label = subjectHash[:label]
        subject.label_en = subjectHash[:labelEn]
        if department = Department.find_by_code(subjectHash[:department])
          subject.departments << department
        else
          Rails.logger.error "Department #{subjectHash[:department_short_name]} could not be found"
        end
        subject.save
      end
    end
  end
end
