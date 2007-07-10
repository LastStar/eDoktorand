class MakeActualStudyPlans < ActiveRecord::Migration
  def self.up
    Index.find(:all).each do |i|
      i.study_plan.update_attribute(:actual, 1) if i.study_plan
    end
    add_index :study_plans, ['actual'], :name => 'actual_idx'
  end

  def self.down
    ActiveRecord::Base.connection.execute('UPDATE study_plans SET actual = NULL') 
    remove_index :study_plans, :name => 'actual_idx'
  end
end
