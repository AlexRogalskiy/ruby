require 'csv'

CSV.foreach("test.csv", headers: true) do |row|
	puts "#{row['Associate']}: #{row['Sales Total']}"
end

if "Tel: 55-0148" =~ /(\d{3}-\d{4})/
	puts "Found phone number: #{$1}"
end

puts "Tel: 555-0148".sub(/\d{3}-\d{4}/, '***-****')

class Person
	def speak
		puts "Hello, there!"
	end
	def method_missing(method_name)
		"Method with name #{method_name.to_s} was called"
	end
end
superhero = Person.new
def superhero.fly
	puts "Up we go!"
end
def superhero.speak
	puts "Off to fight crime!"
end
superhero.fly
superhero.speak