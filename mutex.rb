require 'thread'

def synchronized(o)
	if block_given?
		o.mutex.synchronize { yield }
	else
		SyncronizedObject.new(o)
	end
end

class Object
	def mutex
		return @__mutex if @__mutex
		synchronized(self.class) {
			@__mutex = @__mutex || Mutex.new
		}
	end
end

class SyncronizedObject < BasicObject
	def initialize(o)
		@delegate = o
	end

	def __delegate
		@delegate
	end

	def method_missing(*args, &block)
		@delegate.mutex.synchronize {
			@delegate.send *args, &block
		}
	end
end

Class.instance_eval { @__mutex = Mutex.new }

class Module
	def create_alias(original, prefix="alias")
		aka = "#{prefix}_#{original}"
		aka.gsub!(/([\=\|\&\+\-\*\/\^\!\?\~\%\<\>\[\]])/) {
			num = $1[0]
			num = num.ord if num.is_a? String
			'_' + num.to_s
		}
		aka += "_" while method_defined? aka or private_method_defined? aka
		aka = aka.to_sym
		alias_method aka, original
		aka
	end

	def synchronize_method(m)
		aka = create_alias(m, 'unsync')
		class_eval %Q{
			def #{m}(*args, &block)
				synchronized(self) { #{aka}(*args, &block) }
			end
		}
	end
end

def synchronized(*args)
	if args.size == 1 && block_given?
		args[0].mutex.synchronize { yield }
	elsif args.size == 1 and not args[0].is_a? Symbol and not block_given?
		SyncronizedObject.new(args[0])
	elsif self.is_a? Module and not block_given?
		if(args.size > 0)
			args.each {|m| self.synchronize_method(m)}
		else
			eigenclass = class << self; self; end
			eigenclass.class_eval do
				define_method :method_added do |name|
					eigenclass.class_eval { remove_method :method_added }
					self.synchronize_method name
				end
			end
		end
	else
		raise ArgumentError, "Invalid method arguments"
	end
end