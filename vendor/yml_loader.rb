# loads all yml files in dumps directory 
class YMLLoader
  # provide directory to function and it reads and create all objects 
  def self.load(dir = 'dumps')
    Dir.open(dir).each do |file|
      if file =~ /yml/
        File.open("#{dir}/#{file}", 'r') {|out| YAML.load(out)}.each {|obj| obj.create}
      end
    end
  end
  # creates dumps from classes passed in array to function  
  # TODO
  def self.dump(array, dir = 'dumps')
  end
end


