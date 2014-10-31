require '../../app/controllers/driver_generator'
require '../../app/controllers/html_extractor'

stub_dati = DriverGenerator.new

HtmlExtractor.new(stub_dati.driver)