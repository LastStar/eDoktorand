# loads all yml files in dumps directory 
class YMLLoader
  # provide directory to function and it reads and create all objects 
  def self.load(dir = 'dumps/yml')
    AddressType.destroy_all
    ContactType.destroy_all
    Title.destroy_all
    Study.destroy_all
    Permission.destroy_all
    Role.destroy_all
    File.open("#{dir}/adress_types.yml", 'r') {|out| YAML.load(out)}.each {|obj| obj.create}
    File.open("#{dir}/contact_types.yml", 'r') {|out| YAML.load(out)}.each {|obj| obj.create}
    File.open("#{dir}/titles.yml", 'r') {|out| YAML.load(out)}.each {|obj| obj.create}
    File.open("#{dir}/studies.yml", 'r') {|out| YAML.load(out)}.each {|obj| obj.create}
    File.open("#{dir}/permissions.yml", 'r') {|out| YAML.load(out)}.each {|obj| obj.create}
    File.open("#{dir}/roles.yml", 'r') {|out| YAML.load(out)}.each {|obj| obj.create}
    File.open("#{dir}/permissions_roles.yml", 'r') do |out|
      YAML.load(out)
    end.each do |obj|
      Role.find(obj.first).permissions << Permission.find(obj.last)
    end
  end
  # creates dumps from classes passed in array to function  
  # TODO
  def self.dump( dir = 'dumps/yml')
    File.open("#{dir}/adress_types.yml", 'w') {|out| YAML.dump(AddressType.find(:all), out)}
    File.open("#{dir}/contact_types.yml", 'w') {|out| YAML.dump(ContactType.find(:all), out)}
    File.open("#{dir}/titles.yml", 'w') {|out| YAML.dump(Title.find(:all), out)}
    File.open("#{dir}/studies.yml", 'w') {|out| YAML.dump(Study.find(:all), out)}
    File.open("#{dir}/permissions.yml", 'w') {|out| YAML.dump(Permission.find(:all), out)}
    File.open("#{dir}/roles.yml", 'w') {|out| YAML.dump(Role.find(:all), out)}
    permissions_roles = []
    Role.find(:all).each do |role|
      role.permissions.each do |permission|
        permissions_roles << [role.id, permission.id]
      end
    end
    File.open("#{dir}/permissions_roles.yml", 'w') do |out|
      YAML.dump(permissions_roles, out)
    end
  end
end


