class Statement < ActiveRecord::Base
  untranslate_all
  belongs_to :person
  acts_as_audited

  # returns true if it cancels document
  def cancel?
    return true if self.result == 0 
  end
end
