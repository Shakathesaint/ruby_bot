require 'httparty'

# response = HTTParty.get('http://www.google.it')
#
# puts response.body
# puts response.body, response.code, response.message, response.headers.inspect


class HttpTemp
  include HTTParty
  # base_uri 'http://www.vanbasco.com/it'
  # base_uri 'http://www.vanbasco.com/it'

  def initialize(service, page)
    @options = {body: {searchString: service, nextpage: page}}
    # @options = { query: {q: service} }
  end

  def questions
    self.class.post("http://www.fnovi.it/index.php?pagina=ricerca-iscritti&ricerca=true#searchForm", @options)
    # self.class.get("/search.html", @options)
  end

  def users
    self.class.get("/2.2/users", @options)
  end
end


prova = HttpTemp.new('Rossi', 2)
puts prova.questions

File.open('prova.html', 'w') do |scrivi|
  scrivi << prova.questions
end

