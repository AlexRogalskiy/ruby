class Point
	include Enumerable
	include Comparable

	attr_accessor :x, :y
	#attr_reader :x, :y

	@n = 0
	@totalX = 0
	@totalY = 0

	def self.new(x, y)
		@n += 1
		@totalX += x
		@totalY += y
		super
	end

	def self.report
		puts "Number of points: #@n"
		puts "Average Point X: #{@totalX.to_f/@n}"
		puts "Average Point Y: #{@totalY.to_f/@n}"
	end

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

	class << self
		attr_accessor :n, :totalX, :totalY

		ORIGIN = Point.new(0, 0)
		UNIT_X = Point.new(1, 0)
		UNIT_Y = Point.new(0, 1)
	end

	protected
	private
end

class << Point
	def self.sum(*points)
		x = y = 0
		points.each {|p| x += p.x; y += p.y}
		Point.new(x, y)
	end
end

class Point3D < Point
	attr_accessor :z

	def initialize(x, y, z)
		super(x, y)
		@z = z
	end

	def to_s
		"(#@x, #@y, #@z)"
	end
end

p = Point.new(1, 2)
p.class
p.is_a? Point
p.each {|x| print x}

p.all? {|x| x == 0}

#----------------------------------------------------
#Struct.new("Point2", :x, :y)
Point2 = Struct.new(:x, :y)
class Point2
	#undef x=, y=, []=
	def -@
		Point2.new(-@x, -@y)
	end
end
# class Point3D < Struct.new("Point2", :x, :y, :z)
# end

p = Point2.new(1, 2)
p[:x] = 4
p.each_pair {|x,y| print x, y}
#----------------------------------------------------
class Widget
	def x
		@x
	end
	public :x

	def utility_method
		nil
	end
	private :utility_method
	
	#private_class_method :new
	#public_class_method :new
end

w = Widget.new
w.send :utility_method
w.public_send :x
w.instance_eval { utility_method }
w.instance_eval { @x }
#----------------------------------------------------