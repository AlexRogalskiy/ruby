require 'drb/drb'

obj = []
DRb.start_service("druby://localhost:8787", obj)
20.times do
	sleep 10
	p obj
end