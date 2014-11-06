$dir = '/home/leinad/RubymineProjects/ruby_bot/bot_testing/'

class HtmlExtractor
  require 'selenium-webdriver'

  attr_reader :struttura_dati, :lista_campi_dati

  def initialize(driver, nomefile_json = "#{$dir}struttura_dati.json")
    @driver = driver
    @pagina_iniziale = @driver.current_url # salva la pagina iniziale del browser come pagina di ricerca

    # crea una mappa a partire dal file .json passato
    File.open(nomefile_json, 'r') do |leggi|
      @struttura_dati = JSON.parse(leggi.gets) # gets legge una stringa dal file
    end

    @next_xpath = @struttura_dati[0]
    # @marker_fine_pagina deve essere un elemento che garantisce che la pagina sia stata caricata completamente
    # è consigliato di evitare un elemento funzionalmente collegato alla ricerca perché potrebbe non apparire
    # nella pagina qualora la ricerca non dia risultati o dia risultati di una sola pagina
    @marker_fine_pagina = @struttura_dati[1]
    @lista_campi_dati = @struttura_dati[2]
  end

  # @return [Array] pagine_risultato
  def avvia_ricerca
    # ricerca X, pagina Y

    pagine_risultato = Hash.new # matrice simulata con Hash, viene richiamata con la sintassi pagine_risultato[[x, y]]
    # dove in realtà ogni '[x, y]' è un hash per un relativo valore
    x = 1
    @lista_campi_dati.each do |ricerca|
      y = 1
      campo_input = nil
      ricerca.each do |nomeCampo, testoCampo|
        # continua a riempire i campi finché richiesto
        # la variabile element deve essere globale ($) per poter essere vista dall'esterno del blocco precedente
        campo_input = @driver.find_element(xpath: "#{nomeCampo}")
        campo_input.clear # garantisce che non si scriva sopra ai valori di default del campo
        campo_input.send_keys "#{testoCampo}"
      end

      # avvia la ricerca
      campo_input.submit

      wait_page_load

      @next_page = set_next_button(@next_xpath)
      old_next_page = nil

      # scansione di tutte le pagine risultato Y della ricerca X
      # ciclo do-while, realizzato con il break come suggerisce il creatore di Ruby
      loop do

        # salva il codice html della pagina Y della ricerca X in:
        # file_rXpY.html
        # pagine_risultato[x][y]
        html_source = @driver.page_source
        pagine_risultato[[x-1, y-1]] = html_source
        File.open($dir.to_s + 'file_r' + x.to_s + 'p' + y.to_s + '.html', 'w') do |scrivi|
          scrivi << html_source
        end

        y += 1 # incrementa il numero di pagina
        break if @next_page.nil? or old_next_page == @next_page
        old_next_page = @next_page

        # puts "x1 #{@next_page.location_once_scrolled_into_view}"
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
    pagine_risultato
  end

  # il metodo click() cattura la seguente eccezione StaleElementReferenceError che si verifica quando qualche elemento
  # viene cambiato nella pagina prima ancora che possa essere clickato il pulsante. L'eccezione viene catturata e il metodo
  # rilanciato ricorsivamente finché la pagina non presenta più cambiamenti
  def click(button)
    begin
      ### potrebbe essere che displayed? implichi che l'elemento sia visualizzato A SCHERMO??
      ### in questo caso si spiegherebbe perché non trova il campo next in determinati casi
      # wait = Selenium::WebDriver::Wait.new(:timeout => 10)
      # wait.until { @driver.find_element(xpath: @next_xpath).displayed? }
      button.click
    rescue Selenium::WebDriver::Error::StaleElementReferenceError => e
      errore(e)
      click(button)
    end
  end

  def wait_page_load
    begin
      wait = Selenium::WebDriver::Wait.new(:timeout => 10)
      wait.until { @driver.find_element(xpath: @marker_fine_pagina).displayed? }
    rescue Selenium::WebDriver::Error::StaleElementReferenceError => e
      errore(e)
      wait_page_load
    end
  end

  def set_next_button(next_xpath)
    elementi_corrispondenti = @driver.find_elements(xpath: next_xpath)
    if elementi_corrispondenti.size > 1
      puts "Xpath fornito non univoco: corrisponde a #{@driver.find_elements(xpath: next_xpath).length} elementi"
    end
    # potrebbe essere che l'xpath passato non sia univoco, in tal caso viene considerato
    # valido l'ultimo elemento corrispondente a tale xpath
    displayed?(xpath: next_xpath) ? elementi_corrispondenti.last : nil
  end

  def displayed?(locator)
    # chiama il metodo e ritorna true (supposto che il metodo non lanci un errore)
    @driver.find_element(locator).displayed?
    true
      # se il metodo lancia un errore viene catturato con la rescue
  rescue Selenium::WebDriver::Error::NoSuchElementError => _e
    # errore(e) # non è un errore ma un comportamento previsto
    false
  end

  def errore(e)
    puts "catturata eccezione: #{e} : #{e.backtrace.inspect}"
  end
end