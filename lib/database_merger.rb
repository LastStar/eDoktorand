class DatabaseMerger
  def self.merge(table_name)
    changed = created = not_found = 0
    object_class = eval(table_name.singularize.camelize)
    study_plans = YAML.load(File.open("test/fixtures/#{table_name}.yml"))
    study_plans.keys.each do |key|
      object = object_class.new(study_plans[key])
      object.id = study_plans[key]['id']
      if object_class.exists?(object.id)
        obj = object_class.find(object.id)        
        if object.updated_on && object.updated_on > obj.updated_on
          obj.update_attributes(object.attributes)
          changed += 1
        end
      else
        object.create
        created += 1
      end
    end
    puts "changed #{changed}"
    puts "created #{created}"
  end
end
