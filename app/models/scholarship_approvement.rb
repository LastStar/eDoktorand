class ScholarshipApprovement < Approvement
  belongs_to :faculty, :foreign_key => 'document_id'
  
  def self.approved_for?(faculty)
    from = Time.now - 16.days
    find(:first, 
         :conditions => ['document_id = ? and created_on > ?', faculty, from])
  end
end
