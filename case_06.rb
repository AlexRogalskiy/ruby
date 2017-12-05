class Employee
	attr_reader :name

	def initialize(name = "Anonymous")
		self.name = name
	end

	def name=(name)
		if name == ""
			raise "ERROR: name cannot be blank"
		end
		@name = name
	end

	def print_name
		puts "Name: #{name}"
	end
end

class SalariedEmployee < Employee
	
	attr_reader :salary

	def initialize(name = "Anonymous", salary = 0.0)
		super(name)
		self.salary = salary
	end

	def salary=(salary = 0.0)
		if salary < 0
			raise "ERROR: salary ${salary} is not valid"
		end
		@salary = salary
	end

	def print_pay
		print_name
		pay_for_period = (salary / 365.0) * 14
		formatted_pay = format("%.2f", pay_for_period)
		puts "Pay for the period: #{formatted_pay}"
	end
end

class HourlyEmployee < Employee

	attr_reader :hourly_wage, :hours_per_week

	def self.security_guard(name)
		HourlyEmployee.new(name, 19.25, 30)
	end

	def self.cashier(name)
		HourlyEmployee.new(name, 12.75, 25)
	end

	def self.janitor(name)
		HourlyEmployee.new(name, 10.50, 20)
	end

	def initialize(name = "Anonymous", hourly_wage = 0.0, hours_per_week = 0.0)
		super(name)
		self.hourly_wage = hourly_wage
		self.hours_per_week = hours_per_week
	end

	def hourly_wage=(hourly_wage = 0.0)
		if hourly_wage < 0
			raise "ERROR: salary ${hourly_wage} is not valid"
		end
		@hourly_wage = hourly_wage
	end

	def hours_per_week=(hours_per_week)
		if hourly_wage < 0
			raise "ERROR: salary ${hours_per_week} is not valid"
		end
		@hours_per_week = hours_per_week
	end

	def print_pay
		print_name
		pay_for_period = (hourly_wage * hours_per_week) * 2
		formatted_pay = format("%.2f", pay_for_period)
		puts "Pay for the period: #{formatted_pay}"
	end
end

employee = Employee.new
employee.print_name

def total(prices)
	amount = 0
	prices.each do |price|
		amount += price
	end
	# index = 0
	# while index < prices.length
	# 	amount += prices[index]
	# 	index +=1
	# end
	amount
end
def refund(prices)
	amount = 0
	prices.each do |price|
		amount -= price
	end
	amount
end
def show_discounts(prices)
	index = 0
	prices.each do |price|
		amount_off = price / 3.0
		puts format("Discount: %.2f", amount_off)
		index += 1
	end
end

def method#(&block)
	#block.call(1, 2)
	yield 1, 2
end
method do |p1, p2|
	puts "Block"
	puts p1, p2
end
method {|p1, p2| puts "Block"}

class Array
	def each
		index = 0
		while index < self.length
			yield self[index]
			index += 1
		end
	end

	def fall
		matching_items = []
		self.each do |item|
			if yield(item)
				matching_items << item
			end
		end
		matching_items
	end

	def ffind(search_value)
		relevant_lines = []
		self.each do |line|
			if line.include?(search_value)
				relevant_lines << line
			end
		end
		relevant_lines
	end

	def reject
		kept_items = []
		self.each do |item|
			unless yield(item)
				kept_items << item
			end
		end
		kept_items
	end

	def map
		results = []
		self.each do |item|
			results << yield(item)
		end
		results
	end
end

def pig_latin(word)
	original_length = 0
	new_length = 0
	words.each do |word|
		puts "Original word: #{word}"
		original_length += word.length
		letters = word.chars
		first_letter = letters.shift
		new_word = "#{letters.join}#{first_letter}ay"
		puts "Pig Latin word: #{new_word}"
		new_length += new_word.length
	end
	puts "Total original length: #{original_length}"
	puts "Total Pig Latin length: #{new_length}"
end

review_file = File.open("LICENSE")
lines = review_file.readlines
puts "Line 4: #{lines[3]}"
puts "Line 1: #{lines[0]}"
review_file.close

lines = []
File.open("LICENSE") do |review_file|
	lines = review_file.readlines
end
def find_adjectives(string, search_value)
	words = string.split(" ")
	index = words.find_index(search_value)
	if index
		words[index + 1]
	end
end
relevant_lines = lines.find_all{ |line| line.include?("the") }
reviews = relevant_lines.reject { |line| line.include?("--") }
adjectives = reviews.map{ |review| find_adjectives(review, "and") }
adjectives = adjectives.reject { |line| nil == line }
adjectives = adjectives.map do |adjective|
	"#{adjective.capitalize}"
end
puts adjectives

squares = [2, 3, 4].map{ |number| number ** 2 }
area_codes = ['1-800', '1-402', '1-101'].map do |code|
	code.split("-")[1]
end

def fopen(name, mode)
	file = File.new(name, mode)
	if block_given?
		yield file
	else
		return file
	end
end

def yield_number
	yield 4
end
array = [1, 2, 3]
yield_number { |number| array << number }

sum = 0
[1, 2, 3].each{ |number| sum += number }

def triple
	puts 3 * yield
end
triple { 2 }

def greet
	puts "Hello, #{yield}"
end
greet { "Lizzy" }

def alert
	if yield
		puts "True"
	else
		puts "False"
	end
end
alert { 2 + 2 == 5 }

def one_two
	result = yield(1, 2)
	puts result
end
one_two do |param1, param2|
	param1 + param2
end

[1, 2, 3].find_all { |number| number.even? }
[1, 2, 3].find_all { |number| number.odd? }
[1, 2, 3].find_all { |number| true }
[1, 2, 3].find_all { |number| false }

[1, 2, 3].find { |number| number.even? }
[1, 2, 3].reject { |number| number.odd? }
[1, 2, 3].all? { |number| number.odd? }
[1, 2, 3].any? { |number| number.odd? }
[1, 2, 3].none? { |number| number > 4 }
[1, 2, 3].count { |number| number.odd? }
[1, 2, 3].partition { |number| number.odd? }
['1', '11', '111'].map { |string| string.length }
['1', '11', '111'].max_by { |string| string.length }
['1', '11', '111'].min_by { |string| string.length }

protons = { 1 => "1", 2 => "2", 3 => "3" }
protons = protons.merge({ 3 => "0", 4 => "0" })
protons.each do |key, elem|
	puts "#{key}: #{elem}"
end

votes = Hash.new(0)
lines.each do |line|
	name = line.chomp
	name.upcase!
	votes[name] += 1
end

class Candidate
	attr_accessor :name, :age, :occupation, :hobby, :birthplace

	def initialize(name, age: nil, occupation: nil, hobby: nil, birthplace: "Sleepy Creek")#options = {}
		self.name = name
		self.age = age#options[:age]
		self.occupation = occupation#options[:occupation]
		self.hobby = hobby#options[:hobby]
		self.birthplace = birthplace#options[:birthplace]
	end

	def print_summary(candidate)
		puts "Candidate: #{candidate.name}"
		puts "Age: #{candidate.age}"
		puts "Occupation: #{candidate.occupation}"
		puts "Hobby: #{candidate.hobby}"
		puts "Birthplace: #{candidate.birthplace}"
	end
end

candidate = Candidate.new("Carl Barnes", {:age => 49, :occupation => "Attorney"})
candidate2 = Candidate.new("Carl Barnes", age: 49, occupation: "Attorney")


class LoveInterest
	def request_date
		if @busy
			puts "Busy"
		else
			puts "Okay"
			@busy = true
		end
	end
end

class CelestialBody
	attr_accessor :type, :planet
end

bodies = Hash.new do |hash, key|
	body = CelestialBody.new
	body.type = "planet"
	hash[key] = body
end

foods = Hash.new { |hash, key| hash[key] = [] }
letters = ['a', 'c', 'a', 'b', 'c', 'a']
counts = Hash.new(0)
letters.each do |letter|
	counts[letter] += 1
end

