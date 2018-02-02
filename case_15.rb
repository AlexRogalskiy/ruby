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

#Math.private_class_method *Math.singleton_methods
#Math.public_class_method *Math.singleton_methods
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
s = ""
s.each_byte {|b| print b, " "} # s.bytes.to_a
s.each_line {|s| print s.chomp} # s.lines.to_a
s.each_char {|c| print c, " "} # s.chars.to_a
0.upto(s.length-1) {|n| print s[n, 1], " "}

"one".to_sym
"one".intern
"a".upto("e") {|c| print c}
"".dump # "".inspect
"bead".tr_s("aeiou", " ")
"".sum(8)
"".crypt("ab")

"".count('aeiou')
"".delete('aeiou')
"".squeeze('a-z')
"".count('a-z', '^aeiou')
"".delete('a-z', '^aeiou')

'%d blind %s' % [1, "animal"]

'%5s' % '<<<'
'%-5s' % '>>>'
'%05d' % 123
'%.6e' % 123.456
'%.4g' % 123.456
'%6.4s' % 'ruby'
"%2$s:%3$d: %1$s" % ['Syntax Error', 'test.rb', 20]
#----------------------------------------------------
a = [1, 2, 3, 4, 5]
b = a.pack('i5')
c = b.unpack('i*')
c == a
m = 'hello world'
data = [m.size, m]
template = 'Sa*'
b = data.pack(template)
b.unpack(template)
#----------------------------------------------------
Regexp.new("ruby?")
Regexp.new("ruby?", Regexp::IGNORECASE)
Regexp.compile(".", Regexp::MULTILINE)
pattern = "[a-z]+"
suffix = Regexp.escape("()")
r = Regexp.new(pattern + suffix)
Regexp.union("ruby", "perl", "python", "/Java(Script)?")
Regexp.union("()", "[]", "{}")
#----------------------------------------------------
"hello" =~ /e\w{2}/
$~.string
$~.to_s
$~.pre_match
$~.post_match # Regexp.last_match

pattern = /(Ruby|Perl)(\s+)(rocks|sucks)!/
text = "Ruby rocks!"
pattern =~ text
data = Regexp.last_match
data.size
data.values_at(1, 3)
data.captures
data.begin(0)
data.begin(2)
data.end(2)
data.offset(3)
#----------------------------------------------------
pattern = /(?<lang>Ruby|Perl) (?<ver>\d(\.\d)+) (?<review>rocks|sucks)!/
if(pattern =~ "Ruby 1.9.1 rocks!")
	$~[:lang]
	$~[:ver]
	$~["review"]
	$~.offset(:ver)
end
pattern.names
pattern.named_captures
pattern.match(text) {|data| handle_data(data)}
if /(?<lang>Ruby|Perl) (?<ver>\d(\.\d)+) (?<review>rocks|sucks)!/ =~ "Ruby 1.9 rules!"
	lang
	ver
	review
end
#----------------------------------------------------
require 'English'
$~ #= Regexp.last_match / $LAST_MATCH_INFO
$& #= Regexp.last_match[0] / $MATCh
$` #= Regexp.last_match.pre_match / $PREMATCH
$' #= Regexp.last_match.post_match / $POSTMATCh
$1 #= Regexp.last_match[1]
$+ #= Regexp.last_match[-1] / $LAST_PAREN_MATCH

r = "ruby123"
r.slice!(/\d+/)
"ruby123"[/([a-z]+)(\d+)/,1]

re = /(?<quote>['"])(?<body>[^'"]*)\k<quote>/
puts "".gsub(re, '\k<body>')

pattern = /(['"])([^\1]*)\1/
text.gsub!(pattern) do
	if ($1 == '"')
		"'#$2'"
	else
		"\"#$2\""
	end
end
#----------------------------------------------------
class Numeric
	def milliseconds; self/1000.0; end
	def seconds; self; end
	def minutes; self*60; end
	def hours; self*60*60; end
	def days; self*60*60*24; end
	def weeks; self*60*60*24*7; end

	def to_milliseconds; self*1000; end
	def to_seconds; self; end
	def to_minutes; self/60.0; end
	def to_hours; self/(60*60.0); end
	def to_days; self/(60*60*24.0); end
	def to_weeks; self/(60*60*24*7.0); end
end
#----------------------------------------------------
(5..7).each {|x| print x}
(6..7).each_with_index {|x, i| print x, i}

(1..10).each_slice(4) {|x| print x}
(1..6).each_cons(3) {|x| print x}
data = [1, 2, 3, 4, 5]
roots = data.collect {|x| Math.sqrt(x)}

(1..3).zip([4, 5, 6]) {|x| print x.inspect}
(1..3).zip([4, 5, 6],[7, 8]) {|x| print x}
(1..3).zip('a'..'c') {|x, y| print x, y}

(1..3).to_a == (1..3).entries

require 'set'
(1..3).to_set

e = [1..10].to_enum
e = "test".enum_for(:each_byte)
e = "test".each_byte
"Ruby".each_char.max
iter = "Ruby".each_char
loop { print iter.next }
"Ruby".each_char.with_index.each {|c, i| puts "#{i}:#{c}"}
#----------------------------------------------------
words = ['carrot', 'beet', 'apple']
words.sort_by {|x| x.downcase}
words.sort {|a, b| b<=>a} # a.casecmp(b)

primes = Set[2, 3, 4, 5]
primes.include? 2
primes.member? 1
data = [[1, 2], [0, 1], [7, 8]]
data.find {|x| x.include? 1}
data.detect {|x| x.include? 3}
data.find_index {|x| x.include? 1}

(1..9).select {|x| x%2 == 0}
(1..9).find_all {|x| x%2 == 1}

langs = %w[java perl python ruby]
groups = langs.group_by {|lang| lang[0]}
langs.grep(/^p/) {|x| x.capitalize}

data = [1, 17, 4.0, 3]
ints = data.grep(Integer)
small = ints.grep(0..9)

[1, 2, 3, nil, 4].take_while {|x| x}
[nil, 1, 2].drop_while {|x| x}

sum = (1..5).reduce(:+)
prod = (1..5).reduce(:*)
letter = ('a'..'e').reduce("-", :concat)

sum = (1..6).inject {|total, x| total + x}
max = [1, 3, 4].inject {|m, x| m > x ? m : x}

(-1..10).inject(0) {|num, x| x < 0 ? num + 1 : num}
%w[pea queue are].inject(0) {|total, word| total + word.length}
#----------------------------------------------------
count = Array.new(3) {|i| i+1}
a = Array.new(3) {'b'}
# [1, 2, 3].nitems {|x| x>2}
# a.choice
a.values_at(0...2, 1..3)
a.delete_if {|x| x%2 == 1}
a.reject! {|x| x%2 == 0}
#----------------------------------------------------
a.index {|c| c =~ /[aeiou]/}
a.compact
a.fill(2..4) {'b'}
a.replace([1,2,3])

a.permutation(2) {|x| print x}
a.combination(2) {|x| print x}
a.product(['a','b'])
#----------------------------------------------------
h = {:a => 1, :b => 2}
a = h.to_a
a.assoc(:a)
a.assoc(:b).last
a.rassoc(1)
a.rassoc(2).first
a.transpose
a = [1, 2, 3].zip([:a, :b, :c])
#----------------------------------------------------
Dir.foreach(".") {|f| print f}
Dir['*/*.rb']
file = File.basename('.')
File.dirname('.')
s = File.stat('.')
puts s.directory?
puts File.ftype('.')
File.executable?('.')
File.world_readable?('.')
File.world_writable?('.')
File.zero?('.')
File.size?('.')

test ?e, '.'
test ?s, '.'
test ?r, '.'
test ?w, '.'
f = g = '.'
test ?-, f, g
test ?<, f, g
test ?>, f, g
test ?=, f, g

f = 'testing'
ff = File.open(f, "a:utf-8") {}
ff = File.open(f, "r:binary") {}
ff = File.open(f, "r:iso8859-1:utf-8") {}
# ff.set_encoding(Encoding::UTF-8)

atime = mtime = Time.new
File.truncate(f, 0)
File.utime(atime, mtime, f)
File.chmod(0600, f)
File.delete('testing')

# Dir mkdir("temp")
# File.open("temp/f", "w") {}
# File.delete(*Dir["temp/*"])
# Dir.rmdir("temp")

# File.open("log.txt", "a") do |log|
# 	log.puts("INFO: Logging a message")
# end

# uptime = open("|uptime") {|f| f.gets}
require "open-uri"
f = open("http://www.google.com/")
webpage = f.read
f.close

require "stringio"
input = StringIO.open("")
buffer = ""
output = StringIO.open(buffer, "w")

# lines = ARGF.readlines
# line = DATA.readlines
# print l while l = DATA.gets
# DATA.each {|line| print line}
# DATA.each_line
# DATA.lines
# print while DATA.gets
# ARGF == $<
# ARGV == $*

text = File.read("license")
f = File.open("license")
test = f.read
f.close
#----------------------------------------------------
# DATA.lineno = 0
# DATA.readline
# $.
data = IO.read("license")
data = IO.read("license", 4, 2)
words = IO.readlines("license")
words = {}
IO.foreach("license") {|w| words[w] = true}

f = File.open("license", "r:binary")
c = f.getc
f.ungetc(c)
c = f.readchar

f = File.open("license", "r:binary")
magic = f.read(4)
exit unless magic == "INTS"
bytes = f.read
data = bytes.unpack("i*")
puts data

o = STDOUT
o << "x" << "y"
o.printf fmt,*args

f.seek(10, IO::SEEK_SET)
f.seek(10, IO::SEEK_CUR)
f.seek(-10, IO::SEEK_END)
f.seek(10, IO::SEEK_END)
f.eof?
f.closed?
f.tty?
pos = f.sysseek(10, IO::SEEK_CUR)
f.sysseek(0, IO::SEEK_SET)
f.sysseek(pos, IO::SEEK_SET)
#----------------------------------------------------
begin
	f = File.open("license")
ensure
	f.close if f
end
#----------------------------------------------------
require 'socket'
# ruby file localhost 2000
#host, port = ARGV
host = "http://www.google.ru/"
port = 80
# s = TCPSocket.open(host, port)
# while line = s.gets
# 	puts line.chop
# end
# s.close

# TCPSocket.open(host, port) do |t|
# 	while line = s.gets
# 		puts line.chop
# 	end
# end
# server = TCPServer.open(2000)
# loop {
# 	client = server.accept
# 	client.puts(Time.noew.ctime)
# 	clien.close
# }

# ds = UDPSocket.new
# ds.connect(host, port)
# ds.send(request, 0)
# response, address = ds.recvfrom(1024)
# puts response

# ds = UDPSocket.new
# ds.bind(nil, port)
# loop do
# 	request, address = ds.recvfrom(1024)
# 	response = request.upcase
# 	clientaddr = address[3]
# 	clientname = address[2]
# 	clientport = address[1]
# 	ds.send(response, 0, clientaddr, clientport)
# 	puts "Connection: from #{clientname} #{clientaddr} #{clientport}"
# end
#----------------------------------------------------
def join_all
	main = Thread.main
	current = Thread.current
	all = Thread.list
	all.each {|t| t.join unless t == current or t == main}
end
# Thread.abort_on_exception = true
# t = Thread.new do
# end
# t.abort_on_exception = true

n = 1
while n <= 3
	Thread.new(n) {|x| puts x}
	n += 1
end
1.upto(3) {|n| Thread.new {puts n}}

Thread.current[:progress] = bytes_received
total = 0
thread_pool.each {|t| total += t[:progress] if t.key?(:progress)}
#----------------------------------------------------
# .container
#   %header.sixteen.columns
#     %h1 SpotFindr
#     %h3 123 address
#   %section.eight.columns
#     %h2.price 0
#     %p safsaf
#   %section.eight.columns
#     %h2.price 0
#     %p safsad
#----------------------------------------------------
# groups = ThreadGroup.new
# 3.times {|n| group.add(Thread.new {do_task(n)})}
#----------------------------------------------------
#----------------------------------------------------
#----------------------------------------------------
#----------------------------------------------------
#----------------------------------------------------
#----------------------------------------------------





