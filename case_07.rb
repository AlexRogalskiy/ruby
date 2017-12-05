module CComparable
	def <(other)
		compare(other) == -1
	end

	def >(other)
		compare(other) == 1
	end

	def ==(other)
		compare(other) == 0
	end

	def <=(other)
		comparison = compare(other)
		comparison == -1 || comparison == 0
	end

	def >=(other)
		comparison = compare(other)
		comparison == 1 || comparison == 0
	end

	def between?(first, second)
		compare(first) >=0 && compare(second) <= 0
	end

	def compare(other)
		return (self <=> other)
	end
end

module CEnumerable

	def find_all
		matching_items = []
		self.each do |item|
			if yield(item)
				matching_items << item
			end
		end
		matching_items
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

module CTraceable
	def print(value)
		puts value
	end
end

module AcceptComments
	def comments
		@comments ||= []
	end

	def add_comment(comment)
		comments << comment
	end
end

class Clip
	include AcceptComments
	def play
		puts "Playing #{object_id}..."
	end
end

class Video < Clip
	attr_accessor :resolution
end

class Song < Clip
	attr_accessor :beats_per_minute
end

class Photo
	include AcceptComments

	def initialize
		@format = "JPEG"
	end

	def show
		puts "Displaying #{object_id}"
	end
end

class Steak
	include Comparable

	GRADE_SCORES = { "Prime" => 3, "Choice" => 2, "Select" => 1 }
	
	attr_accessor :grade

	def <=>(other)
		if GRADE_SCORES[self.grade] < GRADE_SCORES[other.grade]
			return -1
		elsif GRADE_SCORES[self.grade] == GRADE_SCORES[other.grade]
			return 0
		else
			return 1
		end
	end
end

prime = Steak.new
prime.grade = "Prime"
choice = Steak.new
choice.grade = "Choice"
select = Steak.new
select.grade = "Select"

puts "prime > choice: #{prime > choice}"
puts "prime < select: #{prime < select}"
puts "select == select: #{select == select}"
puts "select <= select: #{select <= select}"
puts "select >= choise: #{select >= choice}"
puts "choice.between?(select, prime): #{choice.between?(select, prime)}"

class WordSplitter
	include Enumerable
	attr_accessor :string

	def each
		string.split(" ").each do |word|
			yield word
		end
	end
end

splitter = WordSplitter.new
splitter.string = "how do you do"
splitter.find_all { |word| word.include?("d") }
splitter.reject { |word| word.include?("d") }
splitter.map { |word| word.reverse }
splitter.any? { |word| word.include?("e") }
splitter.find { |word| word.include?("beef") }
splitter.group_by { |word| word.include?("beef") }
splitter.max_by { |word| word.length }
splitter.min_by { |word| word.length }
splitter.count
splitter.first
splitter.to_a

"abcd".insert(-1, 'X')
"hello".index(/[aeiou]/, -3)