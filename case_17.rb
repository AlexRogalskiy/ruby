require 'socket'
server = TCPServer.open(2000)
sockets = [server]
log = STDOUT


while true
	ready = select(sockets)
	readable = ready[0]
	readable.each do |socket|
		if socket == server
			client = server.accept
			sockets << client
			client.puts "Service #{Socket.gethostname} is running"
			log.puts "Connection from client #{client.peeraddr[2]}"
		else
			input = socket.gets
			if !input
				log.puts "Client with address #{socket.peeraddr[2]} is disconnected"
				sockets.delete(socket)
				socket.close
				next
			end
			input.chop!
			if input == "quit"
				socket.puts "Closed"
				log.puts "Disconnected from #{socket.peeraddr[2]}"
				sockets.delete(socket)
				socket.close
			else
				socket.puts(input.reverse)
			end
		end
	end
end