file = File.open(ARGV[0]) do |file|
	file.each do |line|
		puts "> " + line
	end
end

File.open(filename) do |f|
	f.each_with_index do |line, number|
		print "#{number} : #{line}"
	end
end