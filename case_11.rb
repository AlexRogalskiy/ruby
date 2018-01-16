def polar(x, y)
	theta = Math.atan2(y, x)
	r = Math.hypot(x, y)
	[r, theta]
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


#!/usr/bin/ruby -w
# -*- coding: utf-8 -*-
require 'socket'
__END__
