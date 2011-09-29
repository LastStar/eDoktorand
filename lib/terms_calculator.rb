class TermsCalculator
  class << self
    def this_year_start
      today = Date.today
      if today.month < 10
        Date.civil(today.year - 1, 9, 30).to_time
      else
        Date.civil(today.year, 9, 30).to_time
      end
    end

    def this_year_end
      today = Date.today
      if today.month < 10
        Date.civil(today.year, 9, 30).to_time
      else
        Date.civil(today.year + 1, 9, 30).to_time
      end
    end

    def current_school_year
      today = Date.today
      if today.month < 10
        "#{today.year - 1}/#{today.year}"
      else
        "#{today.year}/#{today.year + 1}"
      end
    end

    def next_school_year
      today = Date.today.next_year
      if today.month < 10
        "#{today.year - 1}/#{today.year}"
      else
        "#{today.year}/#{today.year + 1}"
      end
    end

    # returns date of begining of scholl year in given calendar year
    def starting_in(year)
      return '%s/10/01' % year
    end

    # returns date of end of scholl year in given calendar year
    def ending_in(year)
      return '%s/09/30' % year
    end

    def idm_next_year
      today = Date.today
      if today.month < 10
        today.year.to_s
      else
        (today.year + 1).to_s
      end
    end

    def idm_current_year
      today = Date.today
      if today.month < 10
        (today.year - 1).to_s
      else
        today.year.to_s
      end
    end
  end
end
