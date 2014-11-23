require '../../app/controllers/client_simulator'
require '../../app/controllers/dynamic_extractor'
require '../../app/controllers/beauti_form'


##############################################################################################
#######  Questo può diventare un test per la classe BeautiForm  ##############################

client                   = ClientSimulator.new 'http://www.fnovi.it/index.php?pagina=ricerca-iscritti'
client.next_xpath        = '//*[@title="Vai alla pagina successiva"]'
client.page_loaded_xpath = '//*[@id="pager"]'
client.add_ricerca({ '//*[@id="searchField"]' => 'Bianchi',
                     # 'xpath2' => 'Mario'
                   },
# { 'xpath_tendina' => 'Roma' }
)
client.add_ricerca '//*[@id="searchField"]' => 'Verdi'
client.to_file_json

driver = Selenium::WebDriver.for :firefox
driver.navigate.to 'http://www.fnovi.it/index.php?pagina=ricerca-iscritti'
seeker = BeautiForm.new driver: driver, force: 'dynamic'

puts '====== CODICE HTML ======'
puts seeker.risultato[:pagine]

puts '====== MODALITA\' ========'
puts seeker.risultato[:mode]


##############################################################################################

# # puts 'main: ' + Dir.pwd