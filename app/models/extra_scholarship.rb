class ExtraScholarship < Scholarship

  validates_length_of :commission_head, :is => 4
  validates_length_of :commission_body, :is => 5
  validates_length_of :commission_tail, :is => 4

  def self.find_all_unpaid_by_index(index)
    find(:all, :conditions => ['index_id = ? and scholarship_month_id = ?',
                                 index, ScholarshipMonth.current.id],
                 :order => 'updated_on desc')
  end

  def print_commission
    [commission_head, commission_body, commission_tail].join('/')
  end

  def code
    if index.foreigner?
      "#{short_code}DCIM"
    else
      "#{short_code}DTUM"
    end
  end

  def disponent
    "#{commission_head}#{commission_body}#{commission_tail}"
  end

  def self.sum_for(user)
    ids = Index.find_for_scholarship(user, :include => :disert_theme).map &:id
    code = "#{user.person.faculty.stipendia_code}900"
    sum(:amount, :conditions => ["index_id in (?) and commission_body = 1121" +
                                 " and commission_tail = 1201" +
                                 " and commission_head = ?" +
                                 " and payed_on is null",
                                  ids, code])
  end
end
