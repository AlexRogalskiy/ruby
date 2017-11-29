module SF
class Gear
	attr_reader :chainring, :cog, :wheel

	def defaults
		{:chainring => 40, :cog => 18}
	end

	def initialize(args)
		args = defaults.merge(args)
		@chainring = args.fetch(:chainring, 40)
		@cog = args.fetch(:cog, 18)
		@wheel = args[:wheel]
		@data = [[622, 20], [622, 23], [559, 30], [559, 40]]
	end

	def ratio
		chainring / cog.to_f
	end

	def gear_inches
		ratio * diameter
	end

	#def wheel
	#	@wheel ||= Wheel.new(rim, tire)
	#end
	def diameter
		wheel.diameter
	end

	Wheel = Struct.new(:rim, :tire) do
		def diameter
			(rim + (tire * 2))
		end
	end

	def diam
		data.collect { |cell|
			cell[0] + (cell[1] * 2)
		}
	end
end

class Wheel
	attr_reader :rim, :tire

	def initialize(rim, tire)
		@rim = rim;
		@tire = tire
	end

	def diameter
		rim + (tire * 2)
	end

	def circumference
		diameter * Math::PI
	end
end
end

module GearWrapper
	def self.gear(args)
		SF::Gear.new({:chainring => args[:chainring], :cog => args[:cog], :wheel => args[:wheel]})
	end
end
@wheel = SF::Wheel.new(26, 1.5)
puts @wheel.circumference

puts GearWrapper.gear(chainring: 51, cog: 11, wheel: @wheel).gear_inches
puts GearWrapper.gear(chainring: 30, cog: 37, wheel: nil).ratio