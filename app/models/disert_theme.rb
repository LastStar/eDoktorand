class DisertTheme < ActiveRecord::Base
  belongs_to :index
  has_one :approvement, :foreign_key => 'document_id'
  validates_presence_of :title
  validates_presence_of :methodology_summary, :on => :update
  validates_presence_of :finishing_to
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


end
