module StudyInterruptsHelper

  # TODO remove all magic numbers
  # prints select for interrupt start date
  def start_month_select
    date_select(:interrupt, :start_on,
                :start_year => Date.today.year - 4,
                :end_year => Date.today.year + 1,
                :use_month_numbers => true,
                :discard_day => true,
                :order => [:year, :month, :day])
  end

  def start_day_select
    date_select(:interrupt, :start_on,
                :start_year => Date.today.year - 1,
                :end_year => Date.today.year,
                :use_month_numbers => true,
                :order => [:year, :month, :day])
  end
end
