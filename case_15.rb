class Point
	include Enumerable
	include Comparable

	attr_accessor :x, :y
	#attr_reader :x, :y

	def initialize(x, y)
		@x, @y = x, y
	end

	def to_s
		"(#@x, #@y)"
	end

	def +(other)
		#raise TypeError, "Invalid input type argument" unless other.is_a? Point
		#raise TypeError, "Invalid input type argument" unless other.respond_to? :x and other.respond_to? :y
		Point.new(@x + other.x, @y + other.y)
	rescue
		raise TypeError, "Invalid input arguments"
	end

	def -@
		Point.new(-@x, -@y)
	end

	def *(scalar)
		Point.new(@x * scalar, @y * scalar)
	end

	def coerce(other)
		[self, other]
	end

	def [](index)
		case index
		when 0, -2
			@x
		when 1, -1
			@y
		when :x, "x"
			@x
		when :y, "y"
			@y
		else
			nil
		end
	end

	def each
		yield @x
		yield @y
	end

	def eql?(o)
		if o.instance_of? Point
			@x.eql?(o.x) && @y.eql?(o.y)
		elsif
			false
		end
	end

	def ==(o)
		@x == o.x && @y == o.y
		rescue
			false
	end

	def hash
		code = 17
		code = 37 * code + @x.hash
		code = 37 * code + @y.hash
		code
	end

	def <=>(other)
		return nil unless other.instance_of? Point
		@x**2 + @y**2 <=> other.x**2 + other.y**2
	end

	def add!(p)
		@x += p.x
		@y += p.y
		self
	end

	def add(p)
		q = self.dup
		q.add!(p)
	end
end

p = Point.new(1, 2)
p.class
p.is_a? Point
p.each {|x| print x}

p.all? {|x| x == 0}

#-------------------------
#Struct.new("Point2", :x, :y)
Point2 = Struct.new(:x, :y)
class Point2
	#undef x=, y=, []=
	def -@
		Point2.new(-@x, -@y)
	end
end

p = Point2.new(1, 2)
p[:x] = 4
p.each_pair {|x,y| print x, y}


