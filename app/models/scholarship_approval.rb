class ScholarshipApproval < Approval
  belongs_to :faculty, :foreign_key => 'document_id'

  HALF_MONTH = 1.month / 2

  named_scope :last_weeks, :conditions => ['created_on > ?', 7.days.ago], :order => 'created_on desc'
  named_scope :current, :conditions => ['created_on > ?', ScholarshipMonth.current.opened_at], :order => 'created_on desc'

  belongs_to :dean_statement

  def self.approve_for(user)
    sa = new(:faculty => user.person.faculty)
    sa.create_dean_statement(:person => user.person)
    sa.save
  end

  def self.approved_for?(faculty)
    faculty = Faculty.find(faculty) unless faculty.is_a? Faculty
    # faculty without stipendia code does not have to be approved
    return true unless faculty.stipendia_code
    return find(:first,
         :conditions => ['document_id = ? and created_on > ?',
           faculty.id, ScholarshipMonth.current.opened_at])
  end

  def self.all_approved?
    return Faculty.find(:all).reject {|f| approved_for?(f)}.empty?
  end
end
