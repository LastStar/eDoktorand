desc "Update pot/po files."
task :updatepo do
  require 'gettext/utils'
  GetText::ActiveRecordParser.init(:activerecord_classes => ["ActiveRecord::Base","Secretary", "Examinator", "Leader"])
  GetText.update_pofiles("phdstudy", Dir.glob("{app,lib,bin}/**/*.{rb,rhtml}"), "phdstudy 1.0")
end

desc "Create mo-files"
task :makemo do
  require 'gettext/utils'
  GetText.create_mofiles(true, "po", "locale")
end
