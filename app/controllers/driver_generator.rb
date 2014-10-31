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
    # @lista_campi_dati[0] = {'searchField' => 'Rossi'}

# 2) esempio

# @struttura_dati[0] = '//*[@id="pagnNextLink"]' # xpath del tasto next
# @struttura_dati[1] = '//*[@id="pagnNextString"]' # marker di fine pagina - garantisce che la pagina ha terminato il caricamento
# @lista_campi_dati[0] = {'//*[@id="twotabsearchtextbox"]' => 'asus g750jx'}
# @lista_campi_dati[1] = {'//*[@id="twotabsearchtextbox"]' => 'isaac asimov'}
# @driver.navigate.to 'http://www.amazon.it/'

# 3) esempio
#     @strutturaDati[0] = '//*[@id="container"]/div[4]/div/div/div[4]/div[2]/div[24]/div/div/ul/li[3]/a' # xpath del tasto next
    @struttura_dati[0] = '//*[@class="listing-pag-n listing-pag-succ"]' # xpath del tasto next
    @struttura_dati[1] = "//*[@id='container']/div[4]/div/div/div[4]/div[2]/div[24]"
    @driver.navigate.to 'http://www.paginebianche.it/'
    @lista_campi_dati[0] = {'//*[@id="input_cosa"]' => 'De Amicis',
                            '//*[@id="input_dove"]' => 'Roma'}
    @lista_campi_dati[1] = {'//*[@id="input_cosa"]' => 'Bonucci',
                            '//*[@id="input_dove"]' => 'Milano'}

    to_file_json
  end

  def to_file_json
    File.open('strutturaDati.json', 'w') do |scrivi|
      scrivi << @struttura_dati.to_json
    end

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

  # def strutturaDati
  #   @strutturaDati
  # end

end