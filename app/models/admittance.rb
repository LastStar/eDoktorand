class Admittance < ActiveRecord::Base
	belongs_to :candidate
	validates_presence_of :skilled_exam, :message => 'Odborná zkouška musí být vyplněna'
	validates_presence_of :first_language, :message => '1. jazyk musí být vyplněn'
	validates_presence_of :second_language, :message => '2. jazyk musí být vyplněn'
	validates_presence_of :passed, :message => 'Celkový výsledek zkoušky musí být vyplněn'
	validates_presence_of :rank, :message => 'Pořadí uchazeče musí být vyplněno'
	validates_presence_of :admit, :message => 'Doporučení přijímací komise musí být vyplněno'
	validates_presence_of :first_examinator, :message => '1. člen komise musí být vyplněn'
	validates_presence_of :second_examinator, :message => '2. člen komise musí být vyplněn'
	validates_presence_of :third_examinator, :message => '3. člen komise musí být vyplněn'
	validates_presence_of :fourth_examinator, :message => '4. člen komise musí být vyplněn'
	validates_presence_of :dean_conclusion_admit, :message => 'Rozhodnutí děkana fakulty musí být vyplněno'
end
