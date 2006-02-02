# Extension to make it easy to read and write data to a file.
class ActiveRecord::Base
  
  # Delete existing data and load fresh from file 
  def self.load_from_file
    connection.delete("delete from #{table_name}")
    if connection.respond_to?(:reset_pk_sequence!)
     connection.reset_pk_sequence!(table_name)
    end

    records = YAML::load( File.open( File.expand_path("db/dumps/#{table_name}.yml", RAILS_ROOT) ) )
    records.each do |record|
      record_copy = self.new(record.attributes)
      record_copy.id = record.id

      # For Single Table Inheritance
      klass_col = record.class.inheritance_column.to_sym
      if record[klass_col]
         record_copy.type = record[klass_col]
      end
      
      record_copy.save
    end
 
    if connection.respond_to?(:reset_pk_sequence!)
     connection.reset_pk_sequence!(table_name)
    end
  end

  # Writes to db/dumps/table_name.yml
  def self.dump_to_file
    write_file(File.expand_path("db/dumps/#{table_name}.yml", RAILS_ROOT), self.find(:all).to_yaml)
  end

  # Writes relations array to db/dumps/table_name_ralations.yml
  def self.dump_habtm_to_file(relations)
    result = []
    self.find_all.each do |record|
      unless record.send(relations).empty?
        result.concat( record.send(relations).inject([]) \
                      { |arr, rel_obj| arr << [record.id, rel_obj.id] } )
      end
    end
    write_file(File.expand_path("db/dumps/#{table_name}_#{relations}.yml", RAILS_ROOT), result.to_yaml)
  end

  # Loads relations array to database
  def self.load_habtm_from_file(relations)
    self.find_all.each {|obj| obj.send(relations).clear}
    YAML.load(File.open("db/dumps/#{table_name}_#{relations}.yml")).each do |rel|
      find(rel.first).send(relations) << eval("#{relations.camelize.singularize}.find(#{rel.last})")
    end
  end

  # Write a file that can be loaded with fixture :some_table in tests.
  def self.to_fixture
    write_file(File.expand_path("test/fixtures/#{table_name}.yml", RAILS_ROOT), 
        self.find(:all).inject({}) { |hsh, record| 
            hsh.merge("record_#{record.id}" => record.attributes) 
          }.to_yaml)
  end

  def self.write_file(path, content)
    f = File.new(path, "w+")
    f.puts content
    f.close
  end

end
