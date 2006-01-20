class ChangeRequisite < ActiveRecord::Migration
  def self.up
    RequisiteSubject.find_all_by_subject_id(9003).each {|rs| 
      rs.update_attribute('requisite_on', 1)}
  end

  def self.down
    RequisiteSubject.find_all_by_subject_id(9003).each {|rs| 
      rs.update_attribute('requisite_on', 2)}
  end
end
