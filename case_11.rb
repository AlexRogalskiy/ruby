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

#!/usr/bin/ruby -w
# -*- coding: utf-8 -*-
require 'socket'
__END__
