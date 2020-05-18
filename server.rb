require 'socket'

server = TCPServer.new('localhost', 3003)

def parse_request(request_line)
	http_method, path_and_params, protocol = request_line.split(" ")
	path, params = path_and_params.split("?")

	params_hsh = (params || "").split("&").each_with_object({}) do |pair, hsh|
		key, value = pair.split("=")
		hsh[key] = value
	end
	[http_method, path, params_hsh]
end

loop do
	client = server.accept

	request_line = client.gets
	next if !request_line || request_line =~ /favicon/
	puts request_line

	http_method, path, params = parse_request(request_line)

	client.puts "HTTP/1.1 200 OK"
	client.puts "Content-Type: text/html"
	client.puts

  client.puts "<html>"
  client.puts "<body>"
  client.puts "<pre>"
  client.puts http_method
  client.puts path
  client.puts params
  client.puts "</pre>"

  number = params['number'].to_i

  client.puts "<h1>The current number is #{number}</h1>"
  client.puts "<a href='?number=#{number + 1}'>Add one</a>"
  client.puts "<a href='?number=#{number - 1}'>Subtract one</a>"

	client.puts "</body>"
  client.puts "</html>"
	client.close
end