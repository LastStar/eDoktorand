class MassProcessor
# approve all indexes 
  def self.mass_approve(indexes)
    indexes.each do |i|
      app = i.study_plan.approvement = StudyPlanApprovement.new
      created = app.created_on = i.study_plan.approved_on = \
        i.enrolled_on + 1.month
      app.tutor_statement = TutorStatement.create('person_id' => i.tutor_id, 
        'result' => 1, 'note' => '', 'created_on' => created)
      app.leader_statement = LeaderStatement.create('person_id' => i.leader.id, 
        'result' => 1, 'note' => '', 'created_on' => created)
      app.dean_statement = DeanStatement.create('person_id' => i.dean.id, 
        'result' => 1, 'note' => 'approved by machine', 'created_on' => created)
      app.save
      i.save
    end
  end
end
