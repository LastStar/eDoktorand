module InteruptsHelper

  # TODO remove all magic numbers 
  # prints select for interupt start date
  def start_date_select
    
    date_select(:interupt, :start_on,
                :start_year => Date.today.year - 4,
                :end_year => Date.today.year + 1,
                :use_month_numbers => true,
                :discard_day => true,
                :order => [:year, :month, :day]
                )

  end
end
