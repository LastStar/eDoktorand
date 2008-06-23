class TermsCalculator
  def self.this_year_start
    today = Date.today
    if today.month < 10
      Date.civil(today.year - 1, 9, 30).to_time
    else
      Date.civil(today.year, 9, 30).to_time
    end
  end

  def self.current_school_year
    today = Date.today
    if today.month < 10
      "#{today.year - 1}/#{today.year}"
    else
      "#{today.year}/#{today.year + 1}"
    end
  end

  def self.next_school_year
    today = Date.today.next_year
    if today.month < 10
      "#{today.year - 1}/#{today.year}"
    else
      "#{today.year}/#{today.year + 1}"
    end
  end
end
