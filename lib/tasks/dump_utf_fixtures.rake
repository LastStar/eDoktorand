
desc "Dump utf8 fixtures into the current environment's database"
task :dump_utf_fixtures => :environment do
  path = ENV['DEST'] || "#{RAILS_ROOT}/test/fixtures"
  db   = ENV['DB']   || 'development'
  sql  = 'SELECT * FROM %s'

  ActiveRecord::Base.establish_connection(db)
  ActiveRecord::Base.connection.execute('SET NAMES UTF8')
  ActiveRecord::Base.connection.select_values('show tables').each do |table_name|
    i = '000'
    File.open("#{path}/#{table_name}.yml", 'wb') do |file|
      file.write ActiveRecord::Base.connection.select_all(sql %
table_name).inject({}) { |hash, record|
        hash["#{table_name}_#{i.succ!}"] = record
        hash
      }.to_yaml
    end
  end
end
