class ExtraScholarship < Scholarship

  def self.find_all_unpayed_by_index(index_id)
    find(:all, :conditions => ['index_id = ? and payed_on is null', index_id])
  end

  def print_commission
    [commission_head, commission_body, commission_tail].join('/')
  end

  def code
    if index.payment_id == 3
      "#{index.faculty.stipendia_code}DCIM"
    else
      "#{index.faculty.stipendia_code}DTUM"
    end
  end

  def disponent
    "#{commission_tail}#{commission_head}#{commission_body}"
  end

  def self.sum_for(user)
    ids = Index.find_for_scholarship(User.find_by_login('husakova'),
                                     :include => []).map &:id
    code = "#{user.person.faculty.stipendia_code}900"
    sum(:amount, :conditions => ["index_id in (?) and commission_body = 1121" +
                                 " and commission_tail = 1201" + 
                                 " and commission_head = ?" +
                                 " and payed_on is null",
                                  ids, code]) 
  end
end
