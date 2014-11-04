require '../../app/controllers/driver_generator'
require '../../app/controllers/html_extractor'

stub_dati = DriverGenerator.new
stub_dati.next_xpath = '//*[@title="Vai alla pagina successiva"]'
stub_dati.page_loaded_xpath = '//*[@id="pager"]'
stub_dati.add_ricerca '//*[@id="searchField"]' => 'Bianchi'
stub_dati.add_ricerca '//*[@id="searchField"]' => 'Verdi'
stub_dati.goto_site = 'http:/www.fnovi.it/index.php?pagina=ricerca-iscritti'
stub_dati.to_file_json 'strutturaDati.json'

# puts 'main: ' + Dir.pwd

#todo HtmlExtractor potrebbe restituire un array contenente tutte le pagine invece dei file .html; questo consentirebbe di gestire meglio i test avendo valori di ritorno interni al codice
extractor = HtmlExtractor.new(stub_dati.driver)
risultato = extractor.avvia_ricerca

puts risultato[[0, 0]]


# puts extractor.struttura_dati
# puts extractor.lista_campi_dati
# stub_dati.driver.quit