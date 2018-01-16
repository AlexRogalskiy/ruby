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

#!/usr/bin/ruby -w
# -*- coding: utf-8 -*-
require 'socket'
__END__