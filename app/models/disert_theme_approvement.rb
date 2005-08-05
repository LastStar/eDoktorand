class DisertThemeApprovement < Approvement
  belongs_to :disert_theme, :foreign_key => 'document_id'
end
