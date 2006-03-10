class AddItsLanguages < ActiveRecord::Migration
  def self.up
    Faculty.find(2).coridors.each do |c|
      add_language_to_corridor(c.id, 
        [1134, 1138, 1135, 1139, 1133, 8038, 1137, 1136]) 
    end
  end

  def self.down
    Faculty.find(2).coridors.each do |c|
      remove_language(c.id, [1134, 1138, 1135, 1139, 1133, 8038, 1137, 1136])
    end
  end

  def self.add_language_to_corridor(corridor_id, subjects)
    subjects.each { |subject_id| LanguageSubject.create('subject_id' =>
        subject_id, "coridor_id" => corridor_id) }
  end

  def self.remove_language(corridor_id, subjects)
    subjects.each do |subject_id|
      LanguageSubject.find_by_subject_id_and_coridor_id(subject_id, corridor_id).destroy
    end
  end
end
