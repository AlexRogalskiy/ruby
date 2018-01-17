def polar(x, y)
	theta = Math.atan2(y, x)
	r = Math.hypot(x, y)
	[r, theta]
end
def cartesian(magnitude, angle)
	[magnitude * Math.cos(angle), magnitude * Math.sin(angle)]
end

birthyear = 2001
generation = case birthyear
			when 1948..1963
				"1"
			when 1964..1976
				"2"
			when 1978..2000
				"3"
			None
				"else"
			end

print birthyear, " => ", generation, "\n"

def confirm?
	while true
		print "Are you sure [y/n]:"
		response = gets
		case response
		when /^[yY]/
			return true
		when /^[nN]/, /^$/
			return false
		end
	end
end

module Stats
	class DataSet
		def initialize(filename)
			IO.foreach(filename) do |line|
				if line[0,1] == "#{}"
					next
				end
			end
		end
	end
end

print 27**(1/3.0), "\n"
even = (34[0] == 0)

y = f(x) if defined? f(x)

(1..10).each {|x| print x if x==3..x>=3}
print "\n"
(1..10).each {|x| print x if x==3...x>=3}

# while line = gets.chomp do
# 	case line
# 	when /^\s*#/
# 		next
# 	when /^quit$/i
# 		break
# 	else
# 		puts line.reverse
# 	end
# end

def hasValue?(x)
	case x
	when nil, [], "", 0
		false
	else
		true
	end
end

x = 0
puts x += 1 while x < 10

a = [1, 2, 3, 4, 5]
puts a.pop until a.empty?

0.step(Math::PI, 0.1) {|x| puts Math.sin(x)}

squares = [1, 2, 3, 4].collect {|x| x * x}
evens = (1..10).select {|x| x % 2 == 0}
odds = (1..10).reject {|x| x % 2 == 0}

data = [1, 4, 7, 8, 23, 46]
sum = data.inject {|sum, x| sum + x}
floatprod = data.inject(1.0) {|p, x| p * x}
max = data.inject {|m, x| m > x ? m : x}

def sequence(n, m, c)
	i = 0
	while(i < n)
		yield m * i + c
		i += 1
	end
end
sequence(3, 4, 5) {|y| puts y}

def circle(r, n)
	n.times do |i|
		angle = Math::PI * 2 * i / n
		yield r * Math.cos(angle), r * Math.sin(angle)
	end
end
circle(1, 4) {|x, y| printf "(%.2f, %.2f)", x, y}

def sequence2(n, m, c)
	i, s = 0, []
	while(i < n)
		y = m * i + c
		yield y if iterator? #block_given?
		s << y
		i += 1
	end
	s
end
sequence2(3, 4, 5)

s = ""
s.enum_for(:each_char).map {|c| c.succ}
"".chars.map {|c| c.succ}

3.times.each {|x| print x}
10.downto(1).select {|x| x % 2 == 0}
"hello".each_byte.to_a

def twice
	if block_given?
		yield
		yield
	else
		self.to_enum(:twice)
	end
end

text = ""
for line, number in text.each_line.with_index
	print "#{number + 1}: #{line}"
end

module Enumerable
	def each_in_snap &block
		snapshot = self.dup
		snapshot.each &block
	end
end

def iterate(it)
	loop {yield it.next}
end
iterate(9.downto(1)) {|x| print x}

def seq(*enumerables, &block)
	enumerables.each do |enumerable|
		enumerable.each(&block)
	end
end

def interleave(*enumerables)
	enumerators = enumerables.map {|e| e.to_enum}
	until enumerators.empty?
		begin
			e = enumerators.shift
			yield e.next
		rescue StopIteration
		else
			enumerators << e
		end
	end
end

def bundle(*enumerables)
	enumerators = enumerables.map {|e| e.to_enum}
	loop {yield enumerators.map {|e| e.next}}
end

a, b, c = [1,2,3], 4..6, 'a'..'e'
seq(a, b, c) {|x| print x}
interleave(a, b, c) {|x| print x}
bundle(a, b, c) {|x| print x}

array = [1, 2, 3, 4, 5, 6, 7, 8, 9]
array.collect do |x|
	if x == nil
		0
	else
		[x, x * x]
	end
end

printer = lambda {|&b| puts b.call}
printer.call {"hi"}

[1, 2, 3].each &->(x, y=10) {print x * y}

def find(array, target)
	array.each_with_index do |element, index|
		return index if (element == target)
	end
end

# while(line = gets.chop)
# 	break if line == "quit"
# 	puts eval(line)
# end
require 'continuation'
$lines = {}
def line(symbol)
	callcc {|c| $lines[symbol] = c}
end
def goto(symbol)
	$lines[symbol].call
end
i = 0
line 10
puts i += 1
goto 10 if i < 5


require 'fiber'
f = g = nil
f = Fiber.new {|x|
	puts "#{x}"
	x = g.transfer(x + 1)
	puts "#{x}"
	x = g.transfer(x + 1)
	x + 1
}
g = Fiber.new {|x|
	puts "#{x}"
	x = f.transfer(x + 1)
	puts "#{x}"
	x = f.transfer(x + 1)
}
puts f.transfer(1)

def fibonacci_gen(x0, y0)
	Fiber.new do
		x, y = x0, y0
		loop do
			Fiber.yield y
			x, y = y, x + y
		end
	end
end
g = fibonacci_gen(0, 1)
10.times {print g.resume, " "}

class FibonacciGen
	include Enumerable
	def initialize
		@x, @y = 0, 1
		@fiber = Fiber.new do
			loop do
				@x, @y = @y, @x + @y
				Fiber.yield @x
			end
		end
	end

	def next
		@fiber.resume
	end

	def rewind
		@x, @y = 0, 1
	end

	def each
		loop {yield self.next}
	end
end
g = FibonacciGen.new
10.times {print g.next, " "}

class Generator
	def initialize(enumerable)
		@enumerable = enumerable
		create_fiber
	end

	def next
		@fiber.resume
	end

	def rewind
		create_fiber
	end

	def create_fiber
		@fiber = Fiber.new do
			@enumerable.each do |x|
				Fiber.yield(x)
			end
			raise StopIteration
		end
	end
end
g = Generator.new(1..10)
loop {print g.next}
g = (1..10).to_enum
loop {print g.next}

def readfiles(filenames)
	threads = filenames.map do |f|
		Thread.new {File.read(f)}
	end
	threads.map {|t| t.value}
end

# n = 100
# if n < 1
# 	raise ArgumentError, "Argument should be >=1, but receieved #{n}", caller
# 	raise TypeError, "Argument should be integer", if not n.is_a? Integer
# end
# y = factorial(x) rescue 0

def factorial(n)
	raise "ERROR: incorrect argument" if n < 1
	return 1 if n == 1
	n * factorial(n - 1)
end

begin
	x = factorial(1)
rescue => ex
	puts "#{ex.class}: #{ex.message}"
end

squareroots = data.collect do |x|
	next 0 if x < 0
	Math.sqrt(x)
end

def prefix(s, len = 1) 
	s[0, len]
end

def suffix(s, index = s.size-1)
	s[index, s.size-index]
end

def append(x, a=[])
	a << x
end

def max(first, *rest)
	max = first
	rest.each {|x| max = x if x < max}
end
max(*"hello, world!".each_char)

# while(line = gets.chop)
# 	next if line[0, 1] == "#{}"
# 	puts eval(line)
# end

def seq2(args)
	n = args[:n] || 0
	m = args[:m] || 1
	c = args[:c] || 0
	a = []
	n.times {|i| a << m*i + c}
	a
end

def seq3(n, m, c)
	i = 0
	while(i < n)
		yield i * m + c
		i += 1
	end
end
seq3(5, 2, 2) {|x| puts x}

def seq4(n, m, c, &b)
	i = 0
	while(i < n)
		b.call(i * m + c)
		i += 1
	end
end
seq4(5, 2, 2) {|x| puts x}

def seq5(n, m, c, b)
	i = 0
	while(i < n)
		b.call(i * m + c)
		i += 1
	end
end
p = Proc.new {|x| puts x}
seq5(5, 2, 2, p)

def max(first, *rest, &block)
	max = first
	rest.each {|x| max = x if x > max}
	block.call(max)
end

#!/usr/bin/ruby -w
# -*- coding: utf-8 -*-
require 'socket'
__END__
