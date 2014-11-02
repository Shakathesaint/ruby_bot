class DriverGenerator
  require 'selenium-webdriver'
  require 'json'

  def initialize
    @driver = Selenium::WebDriver.for :firefox


    @lista_campi_dati = []
    @struttura_dati = []
    @struttura_dati[2] = @lista_campi_dati


# 1) esempio

# @driver.navigate.to 'http:/www.fnovi.it/index.php?pagina=ricerca-iscritti'
# @struttura_dati[0] = '//*[@title="Vai alla pagina successiva"]' # xpath del tasto next
# @struttura_dati[1] = '//*[@id="pager"]' # marker di fine pagina - garantisce che la pagina ha terminato il caricamento
# @lista_campi_dati[0] = {'//*[@id="searchField"]' => 'Rossi'}

# 2) esempio

# @struttura_dati[0] = '//*[@id="pagnNextLink"]' # xpath del tasto next
# @struttura_dati[1] = '//*[@id="pagnNextString"]' # marker di fine pagina - garantisce che la pagina ha terminato il caricamento
# @lista_campi_dati[0] = {'//*[@id="twotabsearchtextbox"]' => 'asus g750jx'}
# @lista_campi_dati[1] = {'//*[@id="twotabsearchtextbox"]' => 'isaac asimov'}
# @driver.navigate.to 'http://www.amazon.it/'

# 3) esempio
# @strutturaDati[0] = '//*[@id="container"]/div[4]/div/div/div[4]/div[2]/div[24]/div/div/ul/li[3]/a' # xpath del tasto next
#     @struttura_dati[0] = '//*[@id="container"]/div[4]/div/div/div[4]/div[2]/div[24]/div/div/ul/li/a' # xpath del tasto next
#     @struttura_dati[0] = '//a[contains(text(), "Successivo")]' # xpath del tasto next

##################
# @struttura_dati[0] = '//*[@class="listing-pag-n listing-pag-succ"]' # xpath del tasto next
# @struttura_dati[1] = '//*[@id="container"]/div[4]'
#
# @driver.navigate.to 'http://www.paginebianche.it/'
# @lista_campi_dati[0] = {:'//*[@id="input_cosa"]' => 'De Amicis',
#                         :'//*[@id="input_dove"]' => 'Roma'}
# @lista_campi_dati[1] = {:'//*[@id="input_cosa"]' => 'Bonucci',
#                         :'//*[@id="input_dove"]' => 'Roma'}

# to_file_json
  end

  def to_file_json (dati = './app/controllers/strutturaDati.json')
    File.open(dati, 'w') do |scrivi|
      scrivi << @struttura_dati.to_json
    end
  end

  ###############
  # metodi SETTER
  ###############

  def site=(url)
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