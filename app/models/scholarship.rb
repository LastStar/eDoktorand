require 'csv'
class Scholarship < ActiveRecord::Base
  
  belongs_to :index
  validates_presence_of :index, :amount
  acts_as_audited

  def self.find_unpayed_by_index(index)
    index = index.id if index.is_a? Index
    find(:first, :conditions => ['index_id = ? and payed_on is null', index])
  end

  def pay!(time = Time.now)
    update_attribute('payed_on', time)
    return csv_row
  end

  def csv_row
    [index.student.sident, code, disponent, amount, nil, nil, nil, 
      (Time.now - 1.month).strftime('%Y%m')]
  end

  def self.pay_and_generate_for(user)
    indices = Index.find_for_scholarship(user, :include => [:disert_theme])
    outfile = ''
    CSV::Writer.generate(outfile, ';') do |csv|
      indices.each do |i|
        if i.has_extra_scholarship?
          i.extra_scholarships.each {|es| csv << es.pay!}
        end
        if i.has_regular_scholarship? 
          if i.regular_scholarship.amount > 0
            csv << i.regular_scholarship.pay!
          end
        end
      end
    end
    outfile
  end
  
  def self.approve_for(user)
    indices = Index.find_for_scholarship(user, :include => [:disert_theme])
    ScholarshipApprovement.create(:faculty => user.person.faculty)
    indices.select do |i|
      approved = false
      if i.has_extra_scholarship?
        i.extra_scholarships.each {|es| es.approve!}
        approved = true
      end
      if i.has_regular_scholarship? 
        if i.regular_scholarship.amount > 0
          i.regular_scholarship.approve!
          approved = true
        end
      end
      approved
    end
  end
  
  def approve!
    update_attribute('approved_on',Time.now)
  end
  
  def short_code
    index.faculty.stipendia_code.to_s[0,2]
  end
end
