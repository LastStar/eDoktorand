class DisertThemeApprovement < Approvement
  belongs_to :disert_theme, :foreign_key => 'document_id'
  # returns index
  def index
    self.disert_theme.index
  end
end
