module Functional

	#data = [[1, 2], [3, 4]]
	#sum = lambda {|x,y| x + y}
	#sums = sum|a
	def apply(enum)
		enum.map &self
	end
	alias | apply

	#data = [1, 2, 4, 5]
	#sum = lambda {|x,y| x + y}
	#total = sum<=data
	def reduce(enum)
		enum.inject &self
	end
	alias <= reduce

	# f = lambda {|x| x * x}
	# g = lambda {|x| x + 1}
	# (f*g)[2]
	# (g*f)[2]

	#p, c = method :polar, method :cartesian
	#(c*p)[2, 4]
	def compose(f)
		if self.respond_to?(:arity) && self.arity == 1
			lambda {|*args| self[f[*args]]}
		else
			lambda {|*args| self[*f[*args]]}
		end
	end
	alias * compose

	#product = lambda {|x,y| x * y}
	#doubler = lambda >> 2
	def apply_head(*first)
		lambda {|*rest| self[*first.concat(rest)]}
	end
	alias >> apply_head

	#dirfference = lambda {|x,y| x - y}
	#decrement = dirfference << 1
	def apply_tail(*last)
		lambda {|*rest| self[*rest.concat(last)]}
	end
	alias << apply_tail

	def memoize
		cache = {}
		lambda {|*args|
			unless cache.has_key?(args)
				cache[args] = self[*args]
			end
			cache[args]
		}
	end
	alias +@ memoize
end

class Proc
	include Functional
end;
class Method
	include Functional
end;

a = [1, 2, 3, 4, 5, 6]
sum = lambda { |x,y| x + y }
dirfference = lambda{|x, y| x - y}
mean = (sum<=a) / a.size
#sum.reduce(a)
#a.inject(&sum)
deviation = dirfference << mean
square = lambda {|x| x * x}
# standardDeviation = Math.sqrt((sum<=square*deviation|a) / (a.size - 1))

# factorial = lambda{|x| return 1 if x == 0; x*factorial[x - 1];}.memoize
# factorial = +lambda {|x| return 1 if x == 0; x * factorial[x - 1]; }.memoize

data = [1, 2, 3].map(&:succ)
puts data

class Symbol
	def to_proc
		lambda {|receiver, *args| receiver.send(self, *args)}
	end

	# creator = :new[Object]
	# doubler = :*[2]
	def [](obj)
		obj.method(self)
	end

	# :singleton[o] = lambda { puts "singleton-method of o" }
	# :class_method[String] = lambda { puts "method of class" }
	def []=(o, f)
		sym = self
		eigenclass = (class << o; self end)
		eigenclass.instance_eval { define_method(sym, f) }
	end
end

class Module
	alias [] instance_method

	#String[:backwards] = lambda { reverse }
	def []=(sym, f)
		self.instance_eval { define_method(sym, f) }
	end
end

class UnboundMethod
	alias [] bind
end

str = String[:reverse].bind('hello').call
puts str

str = String[:reverse]['hello'][]
puts str

Enumerable[:average]= lambda do
	sum, n = 0.0, 0
	self.each {|x| sum += x; n += 1}	
	if n == 0
		nill
	else
		sum / n
	end
end

x = 1
dashes = :*['-']
puts dashes[10]
y = (:+[1]*:*[2])[x]