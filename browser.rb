require 'socket'
require 'json'
 
host = 'localhost'     # The web server
port = 2000                           # Default HTTP port
#path = "/index.html"                 # The file we want 

print "Enter your selection (get/put): "
input = gets.chomp
if input.downcase == 'get'
  # This is the HTTP request we send to fetch a file
  print "Enter path (ie. /index.html): "
  path = gets.chomp
  #path = "/index.html"                 # The file we want   
  request = "GET #{path} HTTP/1.0\r\n\r\n"
  socket = TCPSocket.open(host,port)  # Connect to server
  socket.print(request)               # Send request
else
  #assuming PUT
  print "Enter name: "
  name = gets.chomp
  print "Enter email: "
  email = gets.chomp
  request = "PUT /path/script.rb HTTP/1.0\n"
  body = { :viking => { :name => name, :email => email} }.to_json + "\r\n\r\n"
  puts body
  header = "From: david@mail.com\n"
  header << "User-Agent: HTTPTool/1.0\n"
  header << "Content-Type: application/x-www-form-urlencoded\n"
  header << "Content=Length: #{body.length}\r\n\r\n"
  socket = TCPSocket.open(host,port)  # Connect to server
  socket.print(request)               # Send request
  socket.print(header)
  socket.print(body)
end

response = socket.read              # Read complete response
# Split response at first blank line into headers and body
headers,body = response.split("\r\n\r\n", 2) 
method = headers.split[0]
status = headers.split[1]
puts method
if status =~ /404/
  puts "Error: 404 Received. File Not Found"
elsif status =~ /200/
  print body                          # And display it
else
  puts "#{status} code received"
end