class ScholarshipApprovement < Approvement
  belongs_to :faculty, :foreign_key => 'document_id'
  
  def self.approved_for?(faculty)
    faculty = faculty.id if faculty.is_a? Faculty
    from = Time.now - 16.days
    find(:first, 
         :conditions => ['document_id = ? and created_on > ?', faculty, from])
  end

  def self.all_approved?
    Faculty.find(:all).reject {|f| approved_for?(f)}.empty?
  end
end
