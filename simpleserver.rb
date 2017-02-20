require 'socket'
require 'json'
@server = TCPServer.new('localhost',2000)
@data_posted_by_client = {}
# accepting a client
while true
	@client = @server.accept
	puts "client accepted. reading request..."
	@request = @client.gets
	puts @request
	
	break
end
# parsing request

def status_response(n)
	case n 
	when 200
		"HTTP/1.1 200 OKCupid"
	when 404
		"HTTP/1.1 404 Not Found"
	when 301
		"HTTP/1.1 301 Moved Permanently"
	when 302
		"HTTP/1.1 302 Moved Temporarily"
	when 303 
		"HTTP/1.1 303 See Other"
	when 500
		"HTTP/1.1 500 Server Error"
	end

end
def header_response
	"Date: #{Time.now}
Content-Type: text/html
Content-Length: #{@file.length}
"
end

if @request =~ /^(GET) \/index\.html.*/
	@file = File.read('index.html')
	if @file 
		@client.puts "#{status_response(200)}\n#{header_response}\n#{@file}"
	elsif !@file
		@client.puts (status_response(404) + "\n" + "#{header_response}")
	end
elsif @request =~ /^POST.*/
	@request = @client.gets
	json_string = @request.chomp
	# puts json_string
	params = JSON.parse(json_string)
	@file = File.read("thanks.html")
	@file.gsub!("<%= yield %>","<li>#{params["vikings"]["name"]}</li>\n<li>#{params["vikings"]["email"]}</li>")
	if @file 
		@client.puts "#{status_response(200)}\n#{header_response}\n#{@file}"
	elsif !@file
		@client.puts (status_response(404) + "\n" + "#{header_response}")
	end
else
	@client.puts "Unknown command."
end


@client.close
