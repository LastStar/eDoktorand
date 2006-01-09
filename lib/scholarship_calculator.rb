class ScholarshipCalculator
  AMOUNTS = {
    1 => {0 => 5700, 1 => 6100, 2 => 6400, 3 => 6700, 4 => 7000,
          5 => 7300, 6 => 7600, 7 => 7900, 8 => 7900, 9 => 7900, 
          10 => 7900, 11 => 7900, 'final_exam' => 8400},
    3 => {0 => 4600, 1 => 4900, 2 => 5200, 3 => 5500, 4 => 5800,
          5 => 6100, 6 => 6400, 7 => 6700, 8 => 6700, 9 => 6700,
          10 => 6700, 'final_exam' => 8000},      
    4 => {0 => 4250, 1 => 4250, 2 => 5250, 3 => 5250, 4 => 5750,
          5 => 5750, 6 => 6250, 7 => 6250, 8 => 6250, 9 => 6250,
          10 => 6250, 11 => 6250, 12 => 6250, 13 => 6250, 'final_exam' => 7250},
    5 => {1 => 5800, 2 => 6500, 3 => 7000, 'final_exam' => 7500}       
  }          
          

  # calculates scholarship for student 
  def self.scholarship_for(student)
    case student.faculty.id
      when 1, 3, 4
        by_exams(student.index)
      when 5
        by_year(student.index)
    end
  end

  private
  # calculates stipendia by exams
  def self.by_exams(index)
    amount = 0
    if index.study_plan
      conditions = ["study_plan_id = ? AND finished_on IS NOT NULL", index.study_plan.id]
      ps = PlanSubject.find(:all, :conditions => conditions)
# Ugly hack. God bless us. FLE - credit
      if index.student.faculty.id == 3 && ps.find {|s| s.subject_id == 9003}
        ps.delete_if {|s| s.subject_id == 9003}
        amount = 100
      end
# Another one. FAPPZ seminars
      if index.student.faculty.id == 1
        ps.delete_if {|s| s.subject_id == 9000 || s.subject_id == 9001}
      end
      amount += AMOUNTS[index.student.faculty.id][ps.size]
    else
      amount = AMOUNTS[index.student.faculty.id][0]
    end
  end

  def self.by_year(index)
    AMOUNTS[index.student.faculty.id][index.year]
  end
end
