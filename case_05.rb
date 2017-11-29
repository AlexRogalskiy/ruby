require 'ostruct'
module PartsFactory
	def self.build(config, partsClass = Parts)#partClass = Part, 
		partsClass.new(config.collect{|part_config|
			createPart(part_config)
		})
	end

	def self.createPart(part_config)
		OpenStruct.new(
						name: part_config[0],
						description: part_config[1],
						needs_spare: part_config.fetch(2, true)
					)
	end
end

class Bicycle
	attr_reader :size, :parts

	def initialize(args={})
		@size = args[:size]
		@parts = args[:parts]
	end

	def spares
		parts.spares
	end
end

require 'forwardable'
class Parts
	extend Forwardable
	def_delegators :@parts, :size, :each
	include Enumerable
	attr_reader :parts

	def initialize(parts)
		@parts = parts
	end

	def spares
		parts.select{|part| part.needs_spare}
	end
end

class Part
	attr_reader :name, :description, :needs_spare

	def initialize(args)
		@name = args[:name]
		@description = args[:description]
		@needs_spare = args.fetch(:needs_spare, true)
	end
end

chain = Part.new(name: 'chain', description: '10-speed')
roadTire = Part.new(name: 'tire_size', description: '23')
tape = Part.new(name: 'tape_color', description: 'red')

mountainTire = Part.new(name: 'tire_size', description: '2.1')
frontShock = Part.new(name: 'front_shock', description: 'Front', needs_spare: false)
rearShock = Part.new(name: 'rear_shock', description: 'Rear')

roadBikeParts = Parts.new([chain, roadTire, tape])
roadBike = Bicycle.new(size: 'L', parts: roadBikeParts)
puts roadBike.size
puts roadBike.spares
mountainBikeParts = Parts.new([chain, mountainTire, frontShock, rearShock])
mountainBike = Bicycle.new(size: 'L', parts: mountainBikeParts)
puts mountainBike.size
puts mountainBike.spares

road_config =
			[
				['chain', '10-speed'],
				['tire_size', '23'],
				['tape_color', 'red']
			]
mountain_config =
			[
				['chain', '10-speed'],
				['tire_size', '2.1'],
				['front_shock', 'Manitou', false],
				['rear_shock', 'Fox']
			]
recumbent_config =
			[
				['chain', '9-speed'],
				['tire_size', '28'],
				['flag', 'tall & orange']
			]
roadParts = PartsFactory.build(road_config)
mountainParts = PartsFactory.build(mountain_config)
recumbentParts = PartsFactory.build(recumbent_config)

rBike = Bicycle.new(size: 'LL', parts: roadParts)
puts rBike.spares
mBike = Bicycle.new(size: 'LL', parts: mountainParts)
puts mBike.spares
rrBike = Bicycle.new(size: 'LL', parts: recumbentParts)
puts rrBike.spares
# class Parts
# 	attr_reader :chain, :tire_size

# 	def initialize(args={})
# 		@chain = args[:chain] || defaultChain
# 		@tire_size = args[:tire_size] || defaultTireSize
# 		postInitialize(args)
# 	end

# 	def spares
# 		{tire_size: tire_size, chain: chain}.merge(localSpares)
# 	end

# 	def defaultTireSize
# 		raise NotImplementedError
# 	end

# 	def postInitialize(args)
# 		nil
# 	end

# 	def localSpares
# 		{}
# 	end

# 	def defaultChain
# 		''
# 	end
# end

# class RoadBikeParts < Parts
# 	attr_reader :tape_color

# 	def postInitialize(args)
# 		@tape_color = args[:tape_color]
# 	end

# 	def localSpares
# 		{tape_color: tape_color}
# 	end

# 	def defaultTireSize
# 		'23'
# 	end
# end

# class MountainBikeParts < Parts
# 	attr_reader :front_shock, :rear_shock

# 	def postInitialize(args)
# 		@front_shock = args[:front_shock]
# 		@rear_shock = args[:rear_shock]
# 	end

# 	def localSpares
# 		{front_shock: front_shock, rear_shock: rear_shock}
# 	end

# 	def defaultTireSize
# 		'2.1'
# 	end
# end

# roadBike = Bicycle.new(size: 'L', parts: RoadBikeParts.new(tape_color: 'red'))
# puts roadBike.size
# puts roadBike.spares

# mountainBike = Bicycle.new(size: 'L', parts: MountainBikeParts.new(front_shock: 'Front', rear_shock: 'Rear'))
# puts mountainBike.size
# puts mountainBike.spares