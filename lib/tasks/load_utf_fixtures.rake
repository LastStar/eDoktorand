
desc "Load utf8 fixtures into the current environment's database"
task :load_utf_fixtures => :environment do
  require 'active_record/fixtures'
  load 'student.rb'
  ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)
  $KCODE = 'u'
  require 'jcode'
  ActiveRecord::Base.connection.execute('SET NAMES UTF8')
  Dir.glob(File.join(RAILS_ROOT, 'test', 'fixtures', '*.{yml,csv}')).each do |fixture_file|
    Fixtures.create_fixtures('test/fixtures', File.basename(fixture_file, '.*'))
  end
end
