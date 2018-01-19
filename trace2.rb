class Object
	def trace!(*methods)
		@_traced = @_traced || []
		methods = public_methods(false) if methods.size == 0
		methods.map! {|m| m.to_sym}
		methods -= @_traced
		return if methods.empty?
		@_traced |= methods

		STDERR << "Tracing #{methods.join(', ')} for #{object_id}\n"

		eigenclass = class << self; self; end
		methods.each do |m|
			eigenclass.class_eval %Q{
				def #{m}(*args, &block)
					begin
						STDERR << "Enter: #{m}(\#{args.join(', ')})\n"
						result = super
						STDERR << "Leave: #{m} with \#{result}\n"
						result
					rescue
						STDERR << "ERROR: #{m}: \#{$!.class}: \#{$!.message}"
						raise
					end
				end
			}
		end
	end

	def untrace!(*methods)
		if methods.size == 0
			methods = @_traced
			STDERR << "Untracing all methods for #{object_id}\n"
		else
			methods.map! {|m| m.to_sym}
			methods &= @_traced
			STDERR << "Untracing methods #{methods.join(', ')} for #{object_id}\n"
		end
		@_traced -= methods
		(class << self; self; end).class_eval do
			methods.each do |m|
				remove_method m
			end
		end
		if @traced.empty?
			remove_instance_variable :@_traced
		end
	end
end