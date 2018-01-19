# copyright = Unicode::U0049
# euro = Unicode::U20AC
# infinity = Unicode::U221E
module Unicode
	def self.const_missing(name)
		if name.to_s =~ /^U([0-9a-fA-F]{4,5}|10[0-9a-fA-F]{4})$/
			codepoint = $1.to_i(16)
			utf8 = [codepoint].pack("U")
			utf8.freeze
			const_set(name, utf8)
		else
			raise NameError, "ERROR: undefined Unicode constant Unicode::#{name}"
		end
	end
end