desc 'Load yml files to database. Set environment variables DB
and DB_DEST to specify the target database and destination path for the
files.  DB defaults to development and DB_DEST defaults to RAILS_ROOT/
db/dumps.

This automaticaly loads all models (from directory app/model). See
plugins/ar_fixtures for some fine tuned updates.'

task :load_from_files => :environment do
  path = ENV['DEST'] || "#{RAILS_ROOT}/test/fixtures"
  db   = ENV['DB']   || 'development'

  ActiveRecord::Base.establish_connection(db)
  ActiveRecord::Base.connection.execute('SET NAMES UTF8')

  Dir.open("#{RAILS_ROOT}/app/models/").each do |file|
    if file =~ /[.]rb/
      print file
      model = eval(file.chomp('.rb').camelize)
      if model.superclass == ActiveRecord::Base
        model.load_from_file
      end
    end
  end

  Role.load_habtm_to_file('permissions')
  Role.load_habtm_to_file('users')
  Student.load_habtm_to_file('probation_terms')
  Department.load_habtm_to_file('subjects')

end

