require 'socket'      # Sockets are in standard library

hostname = 'localhost'
port = 2000

s = TCPSocket.open(hostname, port)
#puts s
#puts "Begin"
while line = s.gets   # Read lines from the socket
  puts line.chop      # And print with platform line terminator
end
#puts "End"
s.close               # Close the socket when done