require 'socket'
require 'json'
@server = TCPSocket.new('localhost',2000)
while true
	@request = gets
	if @request =~ /^GET.*/
		@server.puts @request
		@response = @server.read
		puts @response
	elsif @request =~ /^POST.*/
		print "name: "
		@name = gets.chomp
		print "email: "
		@email = gets.chomp
		print "content: "
		@content = gets.chomp
		has = {vikings:{
			name: @name,
			email: @email,
			content_length: @content.length,
			content: @content,
			}}
		json_string = has.to_json
		@server.puts "POST"
		@server.puts json_string 
		puts "done sending to the server"
		puts @server.read
	end
	break
end

