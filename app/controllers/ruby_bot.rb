require '../../app/controllers/client_simulator'
require '../../app/controllers/dynamic_extractor'

stub_dati = ClientSimulator.new
stub_dati.next_xpath = '//*[@title="Vai alla pagina successiva"]'
stub_dati.page_loaded_xpath = '//*[@id="pager"]'
stub_dati.add_ricerca '//*[@id="searchField"]' => 'Bianchi'
stub_dati.add_ricerca '//*[@id="searchField"]' => 'Verdi'
stub_dati.goto_site = 'http:/www.fnovi.it/index.php?pagina=ricerca-iscritti'
stub_dati.to_file_json

# puts 'main: ' + Dir.pwd

extractor = DynamicExtractor.new(stub_dati.driver)
risultato = extractor.avvia_ricerca

puts risultato[[0, 0]]


# puts extractor.struttura_dati
# puts extractor.lista_campi_dati
# stub_dati.driver.quit