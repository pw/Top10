require 'csv'
lines = CSV.readlines('uscities.csv')
n = 0
lines[1..-1].each do |line|
  puts n+=1 
  City.create(name: line[1], state: line[2])
end
