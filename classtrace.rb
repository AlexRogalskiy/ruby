module ClassTrace
	T = []
	if x = ARGV.index("--traceout")
		OUT = File.open(ARGV[x+1], "w")
		ARGV[x, 2] nil
	else
		OUT = STDERR
	end
end

alias original_require require
alias original_load load

def require(file)
	ClassTrace::T << [file, caller[0]]
	original_require(file)
end

def load(*args)
	ClassTrace::T << [args[0], caller[0]]
	original_load(*args)
end

def Object.inherited(c)
	ClassTrace::T << [c, caller[0]]
end

at_exit {
	o = ClassTrace::OUT
	o.puts "="*60
	o.puts "Loaded classes and files"
	o.puts "="*60
	ClassTrace::T.each do |what, where|
		if what.is_a? Class
			o.puts "Defined: #{what.ancestors.join('<-')} from #{where}"
		else
			o.puts "Loaded: #{what} from #{where}"
		end
	end
}