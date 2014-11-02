require '../../app/controllers/driver_generator'
require '../../app/controllers/html_extractor'

stub_dati = DriverGenerator.new

#todo HtmlExtractor potrebbe restituire un array contenente tutte le pagine invece dei file .html; questo consentirebbe di gestire meglio i test avendo valori di ritorno interni al codice
HtmlExtractor.new(stub_dati.driver)
stub_dati.driver.quit