class Atestation < Approvement
  belongs_to :study_plan, :foreign_key => 'document_id'
  has_one :atestation_detail
end
