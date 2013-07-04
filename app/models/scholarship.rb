require 'csv'
class Scholarship < ActiveRecord::Base

  belongs_to :index
  validates_presence_of :index, :amount, :scholarship_month
  belongs_to :scholarship_month

  #TODO remove as soon as possible
  def creator_of_scholarship
    if self.updated_by_id != nil
      if User.exists?(self.updated_by_id)
        return User.find(self.updated_by_id).person.display_name
      else
        return ""
      end
    else
      if User.exists?(self.created_by_id)
        return User.find(self.created_by_id).person.display_name
      else
        return ""
      end
    end
  end

  def payed_on
    'Deprecated. Paying through month'
  end

  def csv_row
    return [index.sident, code, disponent, amount,
            nil, nil, nil, scholarship_month.title]
  end

  def self.pay_and_generate
    month = ScholarshipMonth.current
    scholarships = Scholarship.all(:conditions => ["scholarship_month_id = ? and amount > 0.0",  month.id],
                                   :include => {:index => :student})
    outfile = ''
    CSV::Writer.generate(outfile, ';') do |csv|
      scholarships.each {|s| csv << s.csv_row}
    end
    month.pay!

    return outfile
  end

  def short_code
    index.faculty.stipendia_code.to_s[0,2]
  end
end
