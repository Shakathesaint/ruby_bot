class DriverGenerator
  require 'selenium-webdriver'
  require 'json'

  #todo: modificare la classe per adattarsi alla nuova BeautiForm
  def initialize
    @driver = Selenium::WebDriver.for :firefox
    @lista_campi_dati = []
    @struttura_dati = []
    @struttura_dati[2] = @lista_campi_dati
  end

  # @param [String] dati - nome del file .json da creare (opzionale)
  def to_file_json (dati = "#{$dir}struttura_dati.json")
    File.open(dati, 'w') do |scrivi|
      scrivi << @struttura_dati.to_json
    end
    puts Dir.pwd
  end

  ###############
  # metodi SETTER
  ###############

  # @param [String] url
  def goto_site=(url)
    @driver.navigate.to url
  end

  # @param [String] xpath
  def next_xpath=(xpath)
    @struttura_dati[0] = xpath
  end

  # @param [String] xpath
  def page_loaded_xpath=(xpath)
    @struttura_dati[1] = xpath
  end

  # @param [Hash] hash
  def add_ricerca(hash)
    @lista_campi_dati << hash
  end


###############
# metodi GETTER
###############

# attr_reader :driver, :strutturaDati
# non posso usare attr_reader perché mi restituisce una STRINGA corrispondente ai valori e non l'oggetto
# mi devo perciò definire i miei metodi getter

  def driver
    @driver
  end

  # def quit
  #   @driver.quit
  # end

  # def strutturaDati
  #   @strutturaDati
  # end

end