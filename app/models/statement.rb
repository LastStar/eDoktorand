class Statement < ActiveRecord::Base
  
  belongs_to :person

  # returns true if it cancels document
  def cancel?
    return true if self.result == 0 
  end
end
