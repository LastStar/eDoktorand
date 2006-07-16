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
end
