module ServiceTools
  module Subjects
    # repairs all subjects from subjects service
    def self.repair_all
      subjects = GetSubjectService.get_subjects
      subjects.each do |subjectHash|
        subject = Subject.find_by_code(subjectHash[:code]) || Subject.new(:code => subjectHash[:code])
        subject.label = subjectHash[:label]
        subject.label_en = subjectHash[:label_en]
        if department = Department.find_by_short_name(subjectHash[:department_short_name])
          subject.departments << department
        else
          Rails.logger.error "Department #{subjectHash[:department_short_name]} could not be found"
        end
        subject.save
      end
    end
  end
end
