require 'singleton'
class PointStats
	include Singleton

	def initialize
		@n, @totalX, @totalY = 0, 0.0, 0.0
	end

	def record(point)
		@n += 1
		@totalX += point.x
		@totalY += point.y
	end

	def report
		puts "Number of points: #@n"
		puts "Average coordinate X of Point: #{@totalX/@n}"
		puts "Average coordinate Y of Point: #{@totalY/@n}"
	end
end

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
		PointStats.instance.record(self)
	end

	def initialize(*coords)
		@coords = coords
	end

	ORIGIN = Point.new(0, 0)

	def initialize_copy(o)
		@coords = @coords.dup
	end

	def marshal_dump
		@coords.pack("w*")
	end

	def marshal_load(s)
		@coords = s.unpack("w*")
	end

	def to_s
		"(#@x, #@y) + #{PointStats.instance.report}"
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

	def method_missing(name, *args)
		raise NoSuchMethodError, "Invalid method name #{name} for #{self.class} with args #{args}"
	end

	def Symbol.const_missing(name)
		raise NoSuchConstError, "Invalid const name #{name} for #{self.class}"
	end

	class << self
		attr_accessor :n, :totalX, :totalY

		ORIGIN = Point.new(0, 0)
		UNIT_X = Point.new(1, 0)
		UNIT_Y = Point.new(0, 1)
	end

	def Point.cartesian(x, y)
		new(x, y)
	end

	def Point.polar(r, theta)
		new(r * Math.cos(theta), r * Math.sin(theta))
	end

	#private_class_method : new
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

	def initialize(x, y, z = nil)
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
class Season
	NAMES = %w{ SPRING SUMMER AUTOMN WINTER }
	INSTANCES = []

	def initialize(n)
		@n = n
	end

	def to_s
		NAMES[@n]
	end

	NAMES.each_with_index do |name, index|
		instance = new(index)
		INSTANCES[index] = instance
		const_set name, instance
	end

	def _dump(limit)
		@n.to_s
	end

	def self._load(s)
		INSTANCES[Integer(s)]
	end

	private_class_method :new, :allocate
	private :dup, :clone
end

#----------------------------------------------------
module Base64
	DIGITD = 'ABCDEFGHIJKLMNOQRSTUVWXYZ' \
			 'abcdefghijklmnoqrstuvwxyz' \
			 '0123456789'

	class Encoder
		def encode(data)
		end
	end

	class Decoder
		def decode(text)
		end
	end

	def self.helper
	end

	def method_
	end

	module_function :method_
end

data = nil
text = Base64::Encoder.new.encode(data)
data = Base64::Decoder.new.decode(text)
#----------------------------------------------------
module Iterable
	include Enumerable
	def each
		loop { yield self.next }
	end
end

countdown = Object.new
def countdown.each
	yield 3
	yield 2
	yield 1
end
countdown.extend(Enumerable)
print countdown.sort
print "\n\n"
#----------------------------------------------------
class Object
	def eigenclass
		class << self; self; end
	end
end
#----------------------------------------------------
module Kernel
	A = B = C = D = E = F = "Kernel"
end
A = B = C = D = E = "Object"
class Super
	A = B = C = D = "Super"
end
module Included
	A = B = C = "Included"
end
module Enclosing
	A = B = "Enclosing"

	class Local < Super
		include Included

		A = "Local"
		#Enclosing::Local -> Enclosing -> Included -> Super -> Object -> Kernel
		search = (Module.nesting + self.ancestors + Object.ancestors).uniq

		puts A
		puts B
		puts C
		puts D
		puts E
		puts F
	end
end
#----------------------------------------------------
module M
	class C
		Module.nesting
	end
end
module G
	include M
	def hi
		"hello"
	end
end
s = ""
s.extend(G)
#puts s.hi

G.ancestors
G.include?(M)
G.included_modules
#----------------------------------------------------
MM = Module.new
CC = Class.new
DD = Class.new(CC) {
	include MM
}
DD.to_s
DD.name
#----------------------------------------------------
o = Point.new(1, 2)
o.instance_eval("@x")
String.class_eval {
	def len
		size
	end
}
String.class_eval { alias len size }
String.instance_eval { def empty; ""; end }
#----------------------------------------------------
global_variables
x = 1
local_variables
p = Point.new(1, 2)
Point::ORIGIN.instance_variables
Point.class_variables
Point.constants
#----------------------------------------------------
o = Object.new
o.instance_variable_set(:@x, 0)
o.instance_variable_get(:@x)
o.instance_variable_defined?(:@x)

Object.class_variable_set(:@@x, 1)
Object.class_variable_get(:@@x)
Object.class_variable_defined?(:@@x)

Math.const_set(:EPI, Math::E*Math::PI)
Math.const_get(:EPI, false)
Math.const_defined?(:EPI, false)

o.instance_eval { remove_instance_variable :@x }
Object.class_eval { remove_class_variable(:@@x) }
Math.send :remove_const, :EPI
#----------------------------------------------------
o = ""
o.methods
o.public_methods(false)
o.protected_methods
o.private_methods(false)
def o.single; 1; end
o.singleton_methods

String.instance_methods == "".public_methods
String.instance_methods(false) == "".public_methods(false)
String.public_instance_methods == String.instance_methods
String.protected_instance_methods
String.private_instance_methods
String.singleton_methods

String.public_method_defined? :reverse
String.protected_method_defined? :reverse
String.private_method_defined? :initialize
String.method_defined? :upcase!

"".method(:reverse)
"".public_method(:reverse)
String.instance_method(:reverse)
String.public_instance_method(:reverse)

"".send :upcase
Math.send(:sin, Math::PI/2)
"".send :puts, "world"
"".public_send :upcase
#----------------------------------------------------
def add_method(c, m, &b)
	c.class_eval {
		define_method(m, &b)
	}
end
add_method(String, "greet") { "Hello, " + self }
puts "world".greet

def add_class_method(c, m, &b)
	eigenclass = class << c; self; end
	eigenclass.class_eval {
		define_method(m, &b)
	}
end
add_class_method(String, "greet") {|name| "Hello, " + name}
puts String.greet("world")

String.define_singleton_method(:greet) {|name| "Hello, " + name}

def create_method_alias(c, m, prefix="original")
	n = :"#{prefix}_#{m}"
	c.class_eval {
		alias_method n, m
	}
end
create_method_alias(String, "reverse")
puts "test".original_reverse
#----------------------------------------------------
class Hash
	def method_missing(key, *args)
		text = key.to_s
		if text[-1, 1] == "="
			self[text.chop.to_sym] = args[0]
		else
			self[key]
		end
	end
end
h = {}
h.one = 1
puts h.one
#----------------------------------------------------
String.class_eval { private :reverse }
# "hello".reverse
Math.private_class_method *Math.singleton_methods
Math.public_class_method *Math.singleton_methods
#----------------------------------------------------
def Object.inherited(c)
	puts "class #{c} < #{self}"
end
module Final
	def self.included(c)
		c.instance_eval do
			def inherited(sub)
				raise Exception, "ERROR: cannot create subclass #{sub} for final class #{self}"
			end
		end
	end

	def self.extended(o)
	end
end

def String.method_added(name)
	puts "Method #{name} has been successfully added to class #{self}"
end
def String.singleton_method_added(name)
	puts "Singleton method #{name} has been successfully added to class #{self}"
end
def String.method_removed(name)
	puts "Method #{name} has been successfully removed from class #{self}"
end
def String.method_undefined(name)
	puts "Method #{name} has been successfully undefined in class #{self}"
end
#----------------------------------------------------
module Strict
	def singleton_method_added(name)
		STDERR.puts "ERROR: singleton method #{name} has been added to #{self}"
		eigenclass = class << self; self; end
		eigenclass.class_eval { remove_method name }
	end

	def singleton_method_removed(name)
		puts "ERROR: singleton method #{name} has been removed from #{self}"
	end

	def singleton_method_undefined(name)
		puts "ERROR: singleton method #{name} has been undefined in #{self}"
	end
end
#----------------------------------------------------
STDERR.puts "#{__method__} in #{__FILE__}:#{__LINE__}: incorrect data"
SCRIPT_LINES__ = {__FILE__ => File.readlines(__FILE__)}
SCRIPT_LINES__[__FILE__][__LINE__-1]
trace_var(:$SAFE) {|v|
	puts "Value of $SAFE=#{v} from #{caller[1]}"
}
untrace_var(:$SAFE)
#----------------------------------------------------
ObjectSpace.each_object(Class) {|c| puts c}
#ObjectSpace._id2ref(id)
#ObjectSpace.define_finalizer
#ObjectSpace.undefine_finalizer
#ObjectSpace.garbage_collect == GC.start / GC.enable / GC.disable

# require './afterevery'
# # 1.upto(5) {|x| print x}
# 1.upto(5) do |i|
# 	after i do
# 		puts i
# 	end
# end	
# sleep(5)
# every 1, 6 do |count|
# 	puts count
# 	break if count == 10
# 	count += 1
# end
# sleep(6)
#----------------------------------------------------
class Module
	private

	def readonly(*syms)
		return if syms.size == 0
		code = ""
		syms.each do |s|
			code << "def #{s}; @#{s}; end\n"
		end
		class_eval code
	end

	def readwrite(*syms)
		return if syms.size == 0
		code = ""
		syms.each do |s|
			code << "def #{s}; @#{s}; end\n"
			code << "def #{s}=(value); @#{s} = value; end\n"
		end
		class_eval code

	end
end
#----------------------------------------------------
class Module
	def attributes(hash)
		hash.each_pair do |symbol, default|
			getter = symbol
			setter = :"#{symbol}="
			variable = :"@#{symbol}"
			define_method getter do
				if instance_variable_defined? variable
					instance_variable_get variable
				else
					default
				end
			end
		end
	
		define_method setter do |value|
			instance_variable_set variable, value
		end
	end

	def class_attrs(hash)
		eigenclass = class << self; self; end
		eigenclass.class_eval { attributes(hash) }
	end

	private :attributes, :class_attrs
end
#----------------------------------------------------






