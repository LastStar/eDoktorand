class ScholarshipApprovement < Approvement
  belongs_to :faculty, :foreign_key => 'document_id'
  
  HALF_MONTH = 5.days

  def self.approved_for?(faculty)
    faculty = Faculty.find(faculty) unless faculty.is_a? Faculty
    # faculty without stipendia code does not have to be approved
    return true unless faculty.stipendia_code
    from = Time.now - HALF_MONTH
    return find(:first, 
         :conditions => ['document_id = ? and created_on > ?', faculty.id, from])
  end

  def self.all_approved?
    return Faculty.find(:all).reject {|f| approved_for?(f)}.empty?
  end
end
