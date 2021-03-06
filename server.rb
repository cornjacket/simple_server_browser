require 'socket'               # Get sockets from stdlib
require 'json'

server = TCPServer.open(2000)  # Socket to listen on port 2000
loop {                         # Servers run forever
  client = server.accept       # Wait for a client to connect
  # breaks when it receives /r/n/r/n, but what if that never happens, no timeout
  header = ''
  loop do
    #puts "Inside header loop" #looks like the header is being received here
    header << client.gets
    break if header =~ /\r\n\r\n$/
  end

  method = header.split[0]
  path = header.split[1]

  puts "header = #{header}"
  puts "method = #{method}"
  puts "path = #{path}"

  status_line = ''
  response_header = ''
  response_body = ''
  # path is relative to where the server was initially run
  path = '.' + path
  if method == 'GET' && File.exist?(path)
  	response_body = (File.open(path, 'r')).read
  	status_line = "HTTP/1.0 200 OK"
  	# date should be "Date: Fri, 31 Dec 1999 23:59:59 GMT\n"
  	response_header << "Date: #{Time.now}\n"
    response_header << "Content-Type: text/html\n"
    response_header << "Content-Length: #{response_body.length}\r\n\r\n"
  	#puts response_header
  elsif method == 'PUT' && File.exist?(path) 
    body = ''
    loop do
      #puts "Inside body loop" #looks like the header is being received here
      body << client.gets
      break if body =~ /\r\n\r\n$/  
      # instead of the body
      #puts body
    end
    params = JSON.parse(body.split('\r\n\r\n')[0])
    viking = params['viking']
    name = viking['name']
    email = viking['email']
    status_line = "HTTP/1.0 200 OK"
    response_body = (File.open(path, 'r')).read
    substring = "<li>Name: #{name}</li><li>Email: #{email}</li>"
    response_body.gsub!('<%= yield %>',substring)
    response_header << "Date: #{Time.now}\n"
    response_header << "Content-Type: text/html\n"
    response_header << "Content-Length: #{response_body.length}\r\n\r\n"     
  else
    status_line = "HTTP/1.0 404 Not Found\r\n\r\n"
  end
  client.puts status_line
  client.puts response_header
  client.puts response_body
  client.close                 # Disconnect from the client
  
}