class Schedule
	def scheduled?(schedulable, startDate, endDate)
		puts "This #{schedulable.class} is missed in plan between #{startDate} and #{endDate}"
		false
	end
end

module Schedulable
	attr_writer :schedule

	def schedule
		@schedule ||= ::Schedule.new
	end

	def schedulable?(startDate, endDate)
		!scheduled?(startDate - leadDays, endDate)
	end

	def scheduled?(startDate, endDate)
		schedule.scheduled?(self, startDate, endDate)
	end

	def leadDays
		0
	end
end

#########################################################

class Trip
	attr_reader :bicycles, :customers, :vehicle

	def prepare(prepares)
		# mechanic.prepareBicycles(bicycles)
		#mechanic.each { |preparer|
			# case preparer
			# when Mechanic
			# 	preparer.prepareBicycles(bicycles)
			# when TripCoordinator
			# 	preparer.buyFood(customers)
			# when Driver
			# 	preparer.gasUp(vehicle)
			# 	preparer.fillWaterTank(vehicle)

			# if preparer.kind_of?(Mechanic)
			# if preparer.responds_to?(:prepareBicycles)
			prepares.each {|preparer|
				preparer.prepareTrip(self)
			}
		#}
	end
end

class Vehicle
	include Schedulable

	def leadDays
		3
	end
end

class Mechanic
	include Schedulable

	def prepareBicycles(bicycles)
		bicycles.each {|bicycle| prepareBicycle(bicycle)}
	end

	def prepareBicycle(bicycle)
		#...
	end

	def prepareTrip(trip)
		trip.bicycles.each {|bicycle|
			prepareBicycle(bicycle)
		}
	end
end

class TripCoordinator
	def buyFood(customers)
	end
	def prepareTrip(trip)
		buyFood(trip.customers)
	end
end

class Driver
	def gasUp(vehicle)
	end

	def fillWaterTank(vehicle)
	end

	def prepareTrip(trip)
		gasUp(trip.vehicle)
		fillWaterTank(trip.vehicle)
	end
end

class Bicycle
	include Schedulable
	attr_reader :schedule, :size, :chain, :tire_size

	def initialize(args={})
		@schedule = args[:schedule] || Schedule.new
		@size = args[:size]
		@chain = args[:chain] || defaultChain
		@tire_size = args[:tire_size] || defaultTireSize
		postInitialize(args)
	end

	def leadDays
		1
	end

	def postInitialize(args)
		nil
	end

	def defaultTireSize
		#raise NotImplementedError, "This class #{self.class} cannot respond to:"
		''
	end

	def defaultChain
		'-'
	end

	def spares
		{chain: chain, tire_size: tire_size}.merge(localSpares)
	end

	def localSpares
		{}
	end
end

#bike = Bicycle.new(size: 'M', tape_color: 'red')
#puts bike.size
#puts bike.spares

class MountainBike < Bicycle
	attr_reader :frontShock, :rearShock, :tape_color

	#def initialize(args)
	#	@frontShock = args[:frontShock]
	#	@rearShock =  args[:rearShock]
	#	super(args)
	#end
	def postInitialize(args)
		@frontShock = args[:frontShock]
		@rearShock =  args[:rearShock]
	end

	def defaultTireSize
		'1'
	end

	def localSpares
		{frontShock: frontShock, rearShock: rearShock}
	end

	#def spares
	#	super.merge({frontShock: frontShock, rearShock: rearShock})
	#end
end

class RoadBike < Bicycle
	attr_reader :tape_color

	#def initialize(args)
	#	@tape_color = args[:tape_color]
	#	super(args)
	#end

	def postInitialize(args)
		@tape_color = args[:tape_color]
	end

	def defaultTireSize
		'2'
	end

	#def spares
	#	super.merge({tape_color: tape_color})
	#end

	def localSpares
		{tape_color: tape_color}
	end
end

class RecumbentBike < Bicycle
	attr_reader :flag

	#def initialize(args)
	#	@flag = args[:flag]
	#end

	def postInitialize(args)
		@flag = args[:flag]
	end

	#def spares
	#	super.merge({flag: flag})
	#end

	def defaultChain
		''
	end

	def defaultTireSize
		''
	end

	def localSpares
		{flag: flag}
	end
end

require 'date'
starting = Date.parse("2015/09/04")
ending = Date.parse("2015/09/10")

b = Bicycle.new
b.schedulable?(starting, ending)

roadBike = RoadBike.new(size: 'M', tape_color: 'red')
roadBike.tire_size
puts roadBike.chain

mountainBike = MountainBike.new(size: 'S', frontShock: 'M', rearShock: 'F', tape_color: 'green')
mountainBike.tire_size
puts mountainBike.chain

recumbentBike = RecumbentBike.new(flag: '1')
puts recumbentBike.spares