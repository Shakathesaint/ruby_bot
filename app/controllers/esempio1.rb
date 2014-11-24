require '../../app/controllers/client_simulator'
require '../../app/controllers/dynamic_extractor'
require '../../app/controllers/beauti_form'

######################################
### LATO CLIENT ######################
client                   = ClientSimulator.new 'http://www.fnovi.it/index.php?pagina=ricerca-iscritti'
client.next_xpath        = '//*[@title="Vai alla pagina successiva"]'
client.page_loaded_xpath = '//*[@id="pager"]' # OPZIONALE
client.add_ricerca '//*[@id="searchField"]' => 'Bianchi'
client.add_ricerca '//*[@id="searchField"]' => 'Verdi'
client.to_file_json
######################################


# driver = Selenium::WebDriver.for :firefox
# driver.navigate.to 'http://www.fnovi.it/index.php?pagina=ricerca-iscritti'


seeker   = BeautiForm.new force: :dynamic, silent: :enabled # driver: driver # import: /dir/nomefile.json
pagine   = seeker.risultato[:pagine]
modalita = seeker.risultato[:mode]

seeker.salva_su_file pagine

puts '====== CODICE HTML ======'
puts pagine

puts '====== MODALITA\' ========'
puts modalita


# # puts 'main: ' + Dir.pwd