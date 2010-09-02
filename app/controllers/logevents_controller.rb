class LogeventsController < ApplicationController
  layout 'employers'

  def list
    @logevents = Logevent.all
  end

end
