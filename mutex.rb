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