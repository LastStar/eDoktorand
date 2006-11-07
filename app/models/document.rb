class Document < ActiveRecord::Base
  untranslate_all
  belongs_to :faculty

end
