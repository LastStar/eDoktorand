class ScholarshipCalculator
  AMOUNTS = {
    1 => {0 => 5700, 1 => 6100, 2 => 6400, 3 => 6700, 4 => 7000,
          5 => 7300, 6 => 7600, 7 => 7900, 8 => 8200, 9 => 8500, 
          10 => 8500, 11 => 8500, 'final_exam' => 8900},
    3 => {0 => 4600, 1 => 4900, 2 => 5200, 3 => 5500, 4 => 5800,
          5 => 6100, 6 => 6400, 7 => 6700, 8 => 6700, 9 => 6700,
          10 => 6700, 'final_exam' => 8000},      
    4 => {0 => 4250, 1 => 4250, 2 => 5250, 3 => 5250, 4 => 5750,
          5 => 5750, 6 => 6250, 7 => 6250, 8 => 6250, 9 => 6250,
          10 => 6250, 11 => 6250, 12 => 6250, 13 => 6250, 'final_exam' => 7250},
    5 => {1 => 5800, 2 => 6500, 3 => 7000, 4 => 7000, 'final_exam' => 7500},
    14 => {0 => 4600, 1 => 4900, 2 => 5200, 3 => 5500, 4 => 5800,
          5 => 6100, 6 => 6400, 7 => 6700, 8 => 6700, 9 => 6700,
          10 => 6700, 'final_exam' => 8000},      
    15 => {0 => 4600, 1 => 4900, 2 => 5200, 3 => 5500, 4 => 5800,
          5 => 6100, 6 => 6400, 7 => 6700, 8 => 6700, 9 => 6700,
          10 => 6700, 'final_exam' => 8000}      
  }          
          

  # calculates scholarship for student 
  def self.for(index)
    index = Index.find(index) unless index.is_a?(Index)
    if index.year > 3
      0
    elsif index.payment_id == 3
      7500
    else
      case index.faculty.id
        when 1, 4, 14, 15 
          by_exams(index)
        when 2
          0
        when 5
          by_year(index)
      end
    end
  end

  private
  # calculates stipendia by exams
  def self.by_exams(index)
    amount = 0
    if index.final_exam_passed?
      amount = AMOUNTS[index.faculty.id]['final_exam']
    elsif index.index.study_plan
      conditions = ["study_plan_id = ? AND finished_on IS NOT NULL", index.study_plan.id]
      ps = PlanSubject.find(:all, :conditions => conditions)
      # Ugly hack. God bless us. FLE - credit
      if index.faculty.id == 3 && ps.find {|s| s.subject_id == 9003}
        ps.delete_if {|s| s.subject_id == 9003}
        amount = 100
      end
      amount += AMOUNTS[index.faculty.id][ps.size]
    else
      amount = AMOUNTS[index.faculty.id][0]
    end
  end

  def self.by_year(index)
    AMOUNTS[index.student.faculty.id][index.year]
  end
end
