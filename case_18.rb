require 'net/http'
host = 'http://www.google.com/'
path = 'index.html'

http = Net::HTTP.new(host)
headers, body = http.get(path)
if headers.code == "200"
	print body
else
	puts "Headers: #{headers.code}"
	puts "Message: #{headers.message}"
end

# require 'open-uri'
# open("http://www.google.com/index.html") { |f|
# 	puts f.read
# }