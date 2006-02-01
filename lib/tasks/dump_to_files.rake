desc 'Dump a database to yml files. Set environment variables DB
and DB_DEST to specify the target database and destination path for the
fixtures.  DB defaults to development and DB_DEST defaults to RAILS_ROOT/
db/dumps.

This automaticaly dump all models (from directory app/model). See
plugins/ar_fixtures for some fine tuned updates.'


task :dump_to_files => :environment do
  path = ENV['DEST'] || "#{RAILS_ROOT}/test/fixtures"
  db   = ENV['DB']   || 'development'

  ActiveRecord::Base.establish_connection(db)
  ActiveRecord::Base.connection.execute('SET NAMES UTF8')

  Dir.open("#{RAILS_ROOT}/app/models/").each do |file|
    if file =~ /[.]rb/
      model = eval(file.chomp('.rb').camelize)
      if model.superclass == ActiveRecord::Base
        model.dump_to_file
      end
    end
  end

  Role.dump_habtm_to_file('permissions')
  Role.dump_habtm_to_file('users')
  Student.dump_habtm_to_file('probation_terms')
  Departments.dump_habtm_to_file('subjects')

end

