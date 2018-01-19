require 'thread'

def synchronized(o)
	o.mutex.synchronize { yield }
end

class Object
	def mutex
		return @__mutex if @__mutex
		synchronized(self.class) {
			@__mutex = @__mutex || Mutex.new
		}
	end
end

Class.instance_eval { @__mutex = Mutex.new }