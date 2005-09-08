class DisertTheme < ActiveRecord::Base
  belongs_to :index
  has_one :approvement, :class_name => 'DisertThemeApprovement', :foreign_key => 'document_id'
  validates_presence_of :title
  validates_presence_of :methodology_summary, :on => :update
  validates_presence_of :finishing_to
  acts_as_audited
  def self.save(disert_theme)
    File.open("public/pdf/methodology#{disert_theme['id']}.pdf", "w") do |f|
      f.write(disert_theme['methodology_file'].read) 
    end
  end
  # return true if methodology added
  def has_methodology?
    return true if self.methodology_added_on
  end
  # return true if methodology summary added
  def has_methodology_summary?
    return true if self.methodology_summary
  end
  # returns true if disert theme is approved
  def approved?
    return true unless self.approved_on.nil?
  end
  # resets disert theme
  def reset
    self.methodology_summary = nil
    self.methodology_summary_added_on = nil
    self.methodology_added_on = nil
    self.save
  end
  # aproves disert theme with statement from parameters 
  def approve_with(params)
    statement = \
    eval("#{params['type']}.create(params)") 
    eval("self.approvement.#{params['type'].underscore} =
    statement")
    if statement.cancel?
      self.clone.reset
    elsif statement.is_a?(DeanStatement)
      self.approved_on = Time.now
    end
    if statement.is_a?(LeaderStatement) && !self.approvement.tutor_statement
      self.approvement.tutor_statement =
        TutorStatement.create(statement.attributes)
    end
    self.save
  end
end
