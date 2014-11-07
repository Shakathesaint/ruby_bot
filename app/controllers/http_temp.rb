require 'httparty'

response = HTTParty.get('http://www.google.it')

puts response.body #, response.code, response.message, response.headers.inspect

puts 'end'

class HttpTemp

end