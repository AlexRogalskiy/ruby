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
			else
				"None"
			end

print birthyear, " => ", generation

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