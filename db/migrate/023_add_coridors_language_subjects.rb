class AddCoridorsLanguageSubjects < ActiveRecord::Migration
  def self.up
    LanguageSubject.destroy_all
    Faculty.find(1).coridors.each { |c| add_language_to_corridor(c.id, [9005, 9004, 1134, 1138, 1135, 1139, 8038, 1137, 1136]) }#FAPPS
    Faculty.find(2).coridors.each { |c| add_language_to_corridor(c.id, [1134, 1138, 1135, 1139, 1133, 8038, 1137, 1136]) }
    Faculty.find(3).coridors.each { |c| add_language_to_corridor(c.id, [1134, 1138, 1135, 1139, 1133, 8038, 1137, 1136]) }
    Faculty.find(4).coridors.each { |c| add_language_to_corridor(c.id, [1134, 1138, 1135, 1139, 1133, 8038, 1137, 1136]) }
    Faculty.find(5).coridors.each { |c| add_language_to_corridor(c.id, [1134, 1135, 1139, 1133, 1137, 1136]) }#TF
  end

  def self.down
    LanguageSubject.destroy_all
    add_language_to_corridor(nil, [9005, 9004, 1134, 1138, 1135, 1139, 1133, 8038, 1137, 1136])
  end


  def self.add_language_to_corridor(corridor_id, subjects)
    subjects.each { |subject_id| LanguageSubject.create('subject_id' => subject_id, "coridor_id" => corridor_id) }
  end

end
