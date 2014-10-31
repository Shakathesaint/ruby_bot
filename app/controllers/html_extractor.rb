class HtmlExtractor
  require 'selenium-webdriver'

  def initialize(driver)
    @driver = driver
    @pagina_iniziale = @driver.current_url # salva la pagina iniziale del browser come pagina di ricerca
    @struttura_dati = []

    @markerFinePagina = '//*[@id="pagnNextString"]' # deve essere un elemento che garantisce che la pagina sia stata caricata completamente
    # varia da sito a sito e andrebbe fornito da driver_generator


    # crea una mappa a partire dal file .json passato
    File.open('strutturaDati.json', 'r') do |leggi|
      @struttura_dati = JSON.parse(leggi.gets) # gets legge una stringa dal file
    end

    @next_xpath = @struttura_dati[0]
    @lista_campi_dati = @struttura_dati[1]


    # ricerca X, pagina Y
    x = 1
    @lista_campi_dati.each do |ricerca|
      y = 1
      ricerca.each do |nomeCampo, testoCampo|
        # continua a riempire i campi finché richiesto
        # la variabile element deve essere globale ($) per poter essere vista dall'esterno del blocco precedente
        $element = @driver.find_element(xpath: "#{nomeCampo}")
        $element.send_keys "#{testoCampo}"
      end

      # avvia la ricerca
      $element.submit

      wait_page_load

      @next_page = set_next_button(@next_xpath)

      # scansione di tutte le pagine risultato Y della ricerca X
      # ciclo do-while, realizzato con il break come suggerisce il creatore di Ruby
      loop do

        # salva il codice html della pagina Y della ricerca X nel file:
        # file_rXpY.html
        htmlSource = @driver.page_source
        File.open('file_r' + x.to_s + 'p' + y.to_s + '.html', 'w') do |scrivi|
          scrivi << htmlSource
        end

        y += 1 # incrementa il numero di pagina
        break if @next_page.nil?

        click(@next_page)

        wait_page_load

        @next_page = set_next_button(@next_xpath)
      end
      # inizia una nuova ricerca X
      if x < @lista_campi_dati.length
        @driver.navigate.to @pagina_iniziale
        x += 1
      end
    end
  end

  # il metodo click() cattura la seguente eccezione StaleElementReferenceError che si verifica quando qualche elemento
  # viene cambiato nella pagina prima ancora che possa essere clickato il pulsante. L'eccezione viene catturata e il metodo
  # rilanciato ricorsivamente finché la pagina non presenta più cambiamenti
  def click(button)
    begin
      button.click
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
      click(button)
    end
  end

  def wait_page_load
    begin
      wait = Selenium::WebDriver::Wait.new(:timeout => 20)
      wait.until { @driver.find_element(xpath: @markerFinePagina).displayed? }
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
      wait_page_load
    end
  end

  def set_next_button(next_xpath)
    displayed?(xpath: next_xpath) ? @driver.find_element(xpath: next_xpath) : nil
  end

  def displayed?(locator)
    # chiama il metodo e ritorna true (supposto che il metodo non lanci un errore)
    @driver.find_element(locator).displayed?
    true
      # se il metodo lancia un errore viene catturato con la rescue
  rescue Selenium::WebDriver::Error::NoSuchElementError
    false
  end
end