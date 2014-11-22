require '../../app/controllers/client_simulator'
require '../../app/controllers/dynamic_extractor'
require '../../app/controllers/beauti_form'


##############################################################################################
#######  Questo può diventare un test per la classe BeautiForm  ##############################

client = ClientSimulator.new 'http://www.amazon.it'
client.next_xpath        = '//*[@id="pagnNextLink"]'
# client.page_loaded_xpath = './/*[@id="rightContainerATF"]'
r1                       = { '//*[@id="twotabsearchtextbox"]' => 'asus g750jx' }
drop1  = { '//*[@id="searchDropdownBox"]' => 'Abbigliamento' }
client.add_ricerca r1 #, drop1
client.to_file_json

seeker = BeautiForm.new force: 'dynamic'

puts '====== CODICE HTML ======'
puts seeker.risultato[:pagine]

puts '====== MODALITA\' ========'
puts seeker.risultato[:mode]


##############################################################################################

# # puts 'main: ' + Dir.pwd