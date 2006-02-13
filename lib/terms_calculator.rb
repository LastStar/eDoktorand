class TermsCalculator
  def self.this_year_start
    today = Date.today
    if today.month < 10
      Date.civil(today.year - 1, 9, 30).to_time
    else
      Date.civil(today.year, 9, 30).to_time
    end
  end
end
