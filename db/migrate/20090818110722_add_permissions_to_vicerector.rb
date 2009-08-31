class AddPermissionsToVicerector < ActiveRecord::Migration
  def self.up
    #Actualities
    Role.find(8).permissions <<
    Permission.find_by_name('actualities/show')
    Role.find(8).permissions <<
    Permission.find_by_name('actualities/new')
    Role.find(8).permissions <<
    Permission.find_by_name('actualities/edit')
    Role.find(8).permissions <<
    Permission.find_by_name('actualities/list')
    Role.find(8).permissions <<
    Permission.find_by_name('actualities/index')
    Role.find(8).permissions <<
    Permission.find_by_name('actualities/create')
    Role.find(8).permissions <<
    Permission.find_by_name('actualities/update')
    Role.find(8).permissions <<
    Permission.find_by_name('actualities/destroy')
    #Coridors
    Role.find(8).permissions <<
    Permission.find_by_name('coridors/index')
    Role.find(8).permissions <<
    Permission.create(:name => 'coridors/list')
    Role.find(8).permissions <<
    Permission.find_by_name('coridors/attestation')
    Role.find(8).permissions <<
    Permission.find_by_name('coridors/subjects')
    Role.find(8).permissions <<
    Permission.find_by_name('coridors/del_subject')
    Role.find(8).permissions <<
    Permission.find_by_name('coridors/add_subject')
    Role.find(8).permissions <<
    Permission.find_by_name('coridors/save_coridor_subject')
    #ExamTerms
    Role.find(8).permissions <<
    Permission.find_by_name('exam_terms/index')
    Role.find(8).permissions <<
    Permission.find_by_name('exam_terms/list')
    Role.find(8).permissions <<
    Permission.find_by_name('exam_terms/edit')
    Role.find(8).permissions <<
    Permission.find_by_name('exam_terms/update')
    Role.find(8).permissions <<
    Permission.find_by_name('exam_terms/destroy')
    #Candidates
    Role.find(8).permissions <<
    Permission.find_by_name('candidates/index')
    Role.find(8).permissions <<
    Permission.find_by_name('candidates/list')
    Role.find(8).permissions <<
    Permission.find_by_name('candidates/list_all')
    Role.find(8).permissions <<
    Permission.find_by_name('candidates/set_foreign_payer')
    Role.find(8).permissions <<
    Permission.find_by_name('candidates/show')
    Role.find(8).permissions <<
    Permission.find_by_name('candidates/edit')
    Role.find(8).permissions <<
    Permission.find_by_name('candidates/delete')
    Role.find(8).permissions <<
    Permission.find_by_name('candidates/show')
    Role.find(8).permissions <<
    Permission.find_by_name('candidates/delete_all_candidates')
    Role.find(8).permissions <<
    Permission.find_by_name('candidates/destroy_all_candidates')
    #Examinators
    Role.find(8).permissions <<
    Permission.find_by_name('examinators/index')
    Role.find(8).permissions <<
    Permission.find_by_name('examinators/list')
    Role.find(8).permissions <<
    Permission.find_by_name('examinators/edit')
    Role.find(8).permissions <<
    Permission.find_by_name('examinators/update')
    #Exams
    Role.find(8).permissions <<
    Permission.create(:name => 'exams/list_for_vicerector')
    Role.find(8).permissions <<
    Permission.create(:name => 'exams/list')
    Role.find(8).permissions <<
    Permission.find_by_name('exams/index')
    #Scholarships
    Role.find(8).permissions <<
    Permission.find_by_name('scholarships/list')
    Role.find(8).permissions <<
    Permission.find_by_name('scholarships/index')
    Role.find(8).permissions <<
    Permission.find_by_name('scholarships/prepare')
    Role.find(8).permissions <<
    Permission.find_by_name('scholarships/change')
    Role.find(8).permissions <<
    Permission.find_by_name('scholarships/save')
    Role.find(8).permissions <<
    Permission.find_by_name('scholarships/add')
    Role.find(8).permissions <<
    Permission.find_by_name('scholarships/recalculate')
    Role.find(8).permissions <<
    Permission.find_by_name('scholarships/approve')
    Role.find(8).permissions <<
    Permission.find_by_name('scholarships/control_table')
    #FinalExam
    Role.find(8).permissions <<
    Permission.find_by_name('final_exam_terms/list')
    Role.find(8).permissions <<
    Permission.find_by_name('final_exam_terms/protocol')
    Role.find(8).permissions <<
    Permission.find_by_name('final_exam_terms/prepare_print')
    #Defences
    Role.find(8).permissions <<
    Permission.find_by_name('defenses/list')
    Role.find(8).permissions <<
    Permission.find_by_name('defenses/protocol')
    Role.find(8).permissions <<
    Permission.find_by_name('defenses/announcement')
    
    
    
    
    

  end

  def self.down
    permission = Permission.find_by_name('actualities/show')
    Role.find(8).permissions.delete(permission)
    permission = Permission.find_by_name('actualities/new')
    Role.find(8).permissions.delete(permission)
    permission = Permission.find_by_name('actualities/list')
    Role.find(8).permissions.delete(permission)
    permission = Permission.find_by_name('actualities/index')
    Role.find(8).permissions.delete(permission)
    permission = Permission.find_by_name('actualities/edit')
    Role.find(8).permissions.delete(permission)
    permission = Permission.find_by_name('actualities/create')
    Role.find(8).permissions.delete(permission)
    permission = Permission.find_by_name('actualities/update')
    Role.find(8).permissions.delete(permission)
    permission = Permission.find_by_name('actualities/destroy')
    Role.find(8).permissions.delete(permission)
    permission = Permission.find_by_name('coridors/index')
    Role.find(8).permissions.delete(permission)
    permission = Permission.find_by_name('coridors/list')
    Role.find(8).permissions.delete(permission)
    permission.destroy
    permission = Permission.find_by_name('coridors/attestation')
    Role.find(8).permissions.delete(permission)
    permission = Permission.find_by_name('coridors/subjects')
    Role.find(8).permissions.delete(permission)
    permission = Permission.find_by_name('coridors/del_subject')
    Role.find(8).permissions.delete(permission)
    permission = Permission.find_by_name('coridors/add_subject')
    Role.find(8).permissions.delete(permission)
    permission = Permission.find_by_name('coridors/save_coridor_subject')
    Role.find(8).permissions.delete(permission)
    permission = Permission.find_by_name('exam_terms/index')
    Role.find(8).permissions.delete(permission)
    permission = Permission.find_by_name('exam_terms/list')
    Role.find(8).permissions.delete(permission)
    permission = Permission.find_by_name('exam_terms/edit')
    Role.find(8).permissions.delete(permission)
    permission = Permission.find_by_name('exam_terms/update')
    Role.find(8).permissions.delete(permission)
    permission = Permission.find_by_name('exam_terms/destroy')
    Role.find(8).permissions.delete(permission)
    permission = Permission.find_by_name('candidates/index')
    Role.find(8).permissions.delete(permission)
    permission = Permission.find_by_name('candidates/list')
    Role.find(8).permissions.delete(permission)
    permission = Permission.find_by_name('candidates/set_foreign_payer')
    Role.find(8).permissions.delete(permission)
    permission = Permission.find_by_name('candidates/show')
    Role.find(8).permissions.delete(permission)
    permission = Permission.find_by_name('candidates/edit')
    Role.find(8).permissions.delete(permission)
    permission = Permission.find_by_name('candidates/delete')
    Role.find(8).permissions.delete(permission)
    permission = Permission.find_by_name('candidates/show')
    Role.find(8).permissions.delete(permission)
    permission = Permission.find_by_name('candidates/delete_all_candidates')
    Role.find(8).permissions.delete(permission)
    permission = Permission.find_by_name('candidates/destroy_all_candidates')
    Role.find(8).permissions.delete(permission)
    permission = Permission.find_by_name('examinators/index')
    Role.find(8).permissions.delete(permission)
    permission = Permission.find_by_name('examinators/list')
    Role.find(8).permissions.delete(permission)
    permission = Permission.find_by_name('examinators/edit')
    Role.find(8).permissions.delete(permission)
    permission = Permission.find_by_name('examinators/update')
    Role.find(8).permissions.delete(permission)
    permission = Permission.find_by_name('exams/list_for_vicerector')
    Role.find(8).permissions.delete(permission)
    permission.destroy
    permission = Permission.find_by_name('exams/list')
    Role.find(8).permissions.delete(permission)
    permission.destroy
    permission = Permission.find_by_name('exams/index')
    Role.find(8).permissions.delete(permission)
    permission = Permission.find_by_name('scholarships/list')
    Role.find(8).permissions.delete(permission)  
    permission = Permission.find_by_name('scholarships/index')
    Role.find(8).permissions.delete(permission)  
    permission = Permission.find_by_name('scholarships/prepare')
    Role.find(8).permissions.delete(permission)  
    permission = Permission.find_by_name('scholarships/change')
    Role.find(8).permissions.delete(permission)  
    permission = Permission.find_by_name('scholarships/save')
    Role.find(8).permissions.delete(permission)  
    permission = Permission.find_by_name('scholarships/add')
    Role.find(8).permissions.delete(permission)  
    permission = Permission.find_by_name('scholarships/recalculate')
    Role.find(8).permissions.delete(permission)  
    permission = Permission.find_by_name('scholarships/approve')
    Role.find(8).permissions.delete(permission)  
    permission = Permission.find_by_name('scholarships/control_table')
    Role.find(8).permissions.delete(permission)  
    permission = Permission.find_by_name('final_exam_terms/list')
    Role.find(8).permissions.delete(permission)  
    permission = Permission.find_by_name('final_exam_terms/protocol')
    Role.find(8).permissions.delete(permission)  
    permission = Permission.find_by_name('final_exam_terms/prepare_print')
    Role.find(8).permissions.delete(permission)  
    permission = Permission.find_by_name('defenses/list')
    Role.find(8).permissions.delete(permission)  
    permission = Permission.find_by_name('defenses/protocol')
    Role.find(8).permissions.delete(permission)  
    permission = Permission.find_by_name('defenses/announcement')
    Role.find(8).permissions.delete(permission)  

  end
end
