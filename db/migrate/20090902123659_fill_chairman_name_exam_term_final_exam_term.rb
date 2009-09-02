class FillChairmanNameExamTermFinalExamTerm < ActiveRecord::Migration
  def self.up
    exam_terms = ExamTerm.all
    for exam_term in exam_terms do
      exam_term.chairman_name = Person.find(exam_term.chairman_id).display_name
      exam_term.save
    end  
    final_exam_terms = FinalExamTerm.all
    for final_exam_term in final_exam_terms do
      final_exam_term.chairman_name = Tutor.find(final_exam_term.chairman_id).display_name
      final_exam_term.save
    end  
  end

  def self.down
    exam_terms = ExamTerm.all
    for exam_term in exam_terms do
      exam_term.chairman_name = nil
      exam_term.save
    end  
    final_exam_terms = FinalExamTerm.all
    for final_exam_term in final_exam_terms do
      final_exam_term.chairman_name = nil
      final_exam_term.save
    end  
  end
end
