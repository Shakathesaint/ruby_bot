# $dir = '/home/leinad/RubymineProjects/ruby_bot/bot_testing/'

class DynamicExtractor
	require 'selenium-webdriver'

	# attr_reader :lista_campi_dati, :lista_dropdown

	def initialize(driver, next_xpath, marker_fine_pagina, lista_campi_dati, lista_dropdown = nil)
		@driver          = driver
		@pagina_iniziale = @driver.current_url # salva la pagina iniziale del browser come pagina di ricerca

		@next_xpath         = next_xpath
		@marker_fine_pagina = marker_fine_pagina
		@lista_campi_dati = lista_campi_dati #array di n ricerche da effettuare - ogni elemento è un hash di coppie xpath_campo => valore
		@lista_dropdown   = lista_dropdown #array di n ricerche - ogni elemento è un hash di coppie xpath_menu_tendina => valore da selezionare
	end

	# @return [Hash] pagine_risultato: matrice simulata con Hash, viene richiamata con la sintassi pagine_risultato[[x, y]] dove in realtà ogni '[x, y]' è un hash per un relativo valore
	def avvia_ricerca
		# ricerca X, pagina Y
		pagine_risultato = Hash.new
		x                = 1

		# la sintassi seguente permette di operare parallelamente sui due vettori lista_campi_dati, lista_dropdown
		(0..@lista_campi_dati.size-1).each do |i|
			ricerca_campi    = @lista_campi_dati[i]
			ricerca_dropdown = @lista_dropdown[i]
			y           = 1
			campo_input = nil
			ricerca_campi.each do |xpath_campo, testo_campo|
				# riempie tutti i campi dati
				campo_input = @driver.find_element(xpath: "#{xpath_campo}")
				campo_input.clear # garantisce che non si scriva sopra ai valori di default del campo
				campo_input.send_keys "#{testo_campo}"
			end
			unless ricerca_dropdown.nil?
				# se ci sono compila tutti i menu a tendina
				ricerca_dropdown.each do |xpath_dropdown, selezione|
					dropdown    = @driver.find_element(xpath: "#{xpath_dropdown}")
					select_list = Selenium::WebDriver::Support::Select.new (dropdown)
					select_list.select_by(:text, "#{selezione}")
				end
			end

			# avvia la ricerca
			campo_input.submit
			
			wait_for_page_load

			@next_page    = set_next_button(@next_xpath)
			old_next_page = nil

			# scansione di tutte le pagine risultato Y della ricerca X
			# ciclo do-while, realizzato con il break come suggerisce il creatore di Ruby
			loop do

				# salva il codice html della pagina Y della ricerca X in:
				# file_rXpY.html
				# pagine_risultato[x][y]
				html_source                  = @driver.page_source
				pagine_risultato[[x-1, y-1]] = html_source
				File.open($dir.to_s + 'file_r' + x.to_s + 'p' + y.to_s + '.html', 'w') do |scrivi|
					scrivi << html_source
				end

				y += 1 # incrementa il numero di pagina
				break if @next_page.nil? or old_next_page == @next_page # esce se non c'è più il tasto next oppure
				# c'è ma la pagina non è cambiata
				old_next_page = @next_page

				click(@next_page)

				wait_for_page_load

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

	def click(button)
		begin
			# viene preso il primo elemento appartenente all'array dell'xpath fornito in input
			button.first.click
		rescue Selenium::WebDriver::Error::StaleElementReferenceError => e
			# cattura l'eccezione StaleElementReferenceError che si verifica quando qualche elemento
			# viene cambiato nella pagina prima ancora che possa essere clickato il pulsante. Successivamente il metodo
			# viene rilanciato ricorsivamente finché la pagina non presenta più cambiamenti
			errore(e)
			click(button)
		rescue Selenium::WebDriver::Error::ElementNotVisibleError => e
			# se il primo elemento è hidden lancia ricorsivamente il metodo sul vettore risultante eliminando il primo elemento
			errore(e)
			button.shift
			click(button)
		end
	end

	def wait_for_page_load
		if @marker_fine_pagina.nil?
			wait_page_load_timed(10)
		else
			wait_page_load_manual
		end
	end
	
	#
	# Si basa sul passaggio dell'xpath di un elemento che indica il completo caricamento della pagina.
	# Finché tale elemento non è presente la pagina non viene considerata caricata completamente
	#
	def wait_page_load_manual
		begin
			wait = Selenium::WebDriver::Wait.new(:timeout => 10)
			wait.until { @driver.find_element(xpath: @marker_fine_pagina).displayed? }
		rescue Selenium::WebDriver::Error::StaleElementReferenceError => e
			# cattura l'eccezione StaleElementReferenceError che si verifica quando qualche elemento
			# viene cambiato nella pagina prima ancora che possa essere clickato il pulsante. Successivamente il metodo
			# viene rilanciato ricorsivamente finché la pagina non presenta più cambiamenti
			errore("Non è stato trovato un marker_fine_pagina valido -- #{e}")
			wait_page_load_manual
		end
	end

	#
	# Si basa su un sistema di individuazione automatica (con timeout) del caricamento della pagina per determinare
	# se la pagina ha completato il caricamento
	#
	# @param [Float] timeout tempo massimo di attesa in secondi prima di abortire il caricamento
	# @return [Bool] true se la pagina ha completato il caricamento, false altrimenti
	def wait_page_load_timed(timeout)
		# current_size rappresenta la dimensione totale della pagina, questa viene misurata ad intervalli di tempo
		# dati da time_slice_sec: quando la dimensione non varia più la pagina viene considerata completamente caricata
		current_size   = 0
		timeout_sec    = timeout
		time_slice_sec = 1

		loop do
			previous_size = current_size
			sleep(time_slice_sec)
			timeout_sec = timeout_sec - time_slice_sec

			current_size = @driver.find_element(xpath: '//*').size

			break if  timeout_sec > 0 and previous_size == current_size
		end
		unless timeout_sec > 0
			errore('La pagina non ha completato il caricamento')
			raise
		end
	end


	def set_next_button(next_xpath)
		elementi_corrispondenti = @driver.find_elements(xpath: next_xpath)
		if elementi_corrispondenti.size > 1
			puts "Xpath fornito non univoco: corrisponde a #{@driver.find_elements(xpath: next_xpath).length} elementi"
		end
		# potrebbe essere che l'xpath passato non sia univoco, in tal caso viene considerato
		# valido l'ultimo elemento corrispondente a tale xpath
		if displayed?(xpath: next_xpath) then
			elementi_corrispondenti
			# restituisco l'intero array di elementi corrispondenti all'xpath fornito
			# il metodo click si occuperà di scartare quelli eventualmente non validi perché non clickabili
		else
			nil
		end
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
		puts "catturata eccezione: #{e}" # : #{e.backtrace.inspect}"
	end
end