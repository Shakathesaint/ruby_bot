=begin

E' la classe che si interfaccia col mondo esterno:

1) riceve i dati in ingresso sotto forma di file .json
2) decide a quale metodo affidare la ricerca: statico o dinamico (affidandosi a PageAnalyser)
3) crea dal file .json delle strutture compatibili con le due sottoclassi
		(è necessario spostare tutte le funzioni di lettura del file .json dalla classe dinamica a questa)

=end

$dir = '/home/leinad/RubymineProjects/ruby_bot/bot_testing/'

# @param [Hash] options - import: [percorso del file .json da importare]; force: forza modalità 'static' o 'dynamic'; driver: [passa un driver di Selenium preesistente]
class BeautiForm
	attr_reader :risultato, :url, :lista_dropdown, :driver, :marker_fine_pagina, :page, :lista_campi_dati, :next_xpath
	require 'selenium-webdriver'
	require 'json'
	require 'headless'
	require_relative '../../app/controllers/page_analyzer'
	require_relative '../../app/controllers/static_extractor'
	require_relative '../../app/controllers/dynamic_extractor'


	def initialize(options = {})
		nomefile_json = options[:import] ||= "#{$dir}struttura_dati.json"
		# mode può assumere i valori {force: :static} o {force: :dynamic},
		# se lasciato vuoto viene deciso in automatico se lanciare una ricerca statica o dinamica
		mode          = options[:force] ||= nil
		# il driver può essere passato come parametro alla classe o creato dal metodo ricerca_dinamica
		@driver                = options[:driver] ||= nil
		# la modalità silenziosa prevede l'utilizzo della libreria Headless per la modalità dinamica
		# che evita la visualizzazione a schermo delle operazioni effettuate dal browser
		@esecuzione_silenziosa = options[:silent] ||= nil

		File.open(nomefile_json, 'r') do |leggi|
			@struttura_dati = JSON.parse(leggi.gets) # gets legge una stringa dal file
		end

		@url = @struttura_dati['url']

		#todo: chiedere se posso generare io il driver di Selenium, sembra una scelta più logica in quanto andrebbe creato solo se la ricerca è DINAMICA

		################  USATE SOLO DALLA RICERCA DINAMICA  #######################################################
		@next_xpath         = @struttura_dati['next_xpath']


		# @marker_fine_pagina deve essere un elemento che garantisce che la pagina sia stata caricata completamente.
		# Non esiste infatti in Selenium un metodo per garantire che una pagina abbia completato il caricamento.
		# E' consigliato evitare un elemento funzionalmente collegato alla ricerca perché potrebbe non apparire
		# nella pagina qualora la ricerca non desse risultati o desse risultati di una sola pagina

		# NOTA: @marker_fine_pagina può essere anche completamente omesso, nel qual caso verrà utilizzato un sistema
		# di identificazione automatica del completato caricamento basato su check a intervalli temporali
		# (vedi metodo wait_page_load_timed in DynamicExtractor)
		@marker_fine_pagina = @struttura_dati['marker_fine_pagina']
		############################################################################################################

		@lista_campi_dati   = []
		@lista_dropdown     = []

		ricerche = @struttura_dati['ricerche'] #array
		ricerche.each do |ricerca|
			@lista_campi_dati << ricerca[0]
			@lista_dropdown << ricerca[1]
		end

		################  MODALITA' D'USO DI lista_dropdown  #######################################################
		# 	L'utente può scegliere di passare o meno la lista_dropdown.
		#   Se non viene passata non verrà incluso nessun parametro relativo nella GET/POST, in quanto è necessario
		#   che venga fornito un xpath dall'esterno per identificare in modo univoco il menu a tendina voluto (notare che finora
		#   i siti provati funzionano ugualmente con opzione di default se non si passano parametri relativi alla select).
		#
		# 	Se scegli di passare lista_dropdown questa può essere del tipo:
		#
		# 	{ xpath => 'opzione da selezionare' }
		#
		# 			oppure
		#
		# 	{ xpath => '' }
		#
		# 	Nell'ultimo caso verrà passato come parametro l'elemento identificato nella pagina da selected="selected" (che in HTML
		# 	indica l'opzione di default)
		############################################################################################################

		xpath_primo_campo = @lista_campi_dati[0].keys.first

		@page = PageAnalyzer.new(@url, xpath_primo_campo)

		case mode
			when :static
				ricerca_statica
			when :dynamic
				ricerca_dinamica
			else # comportamento di default (se non viene forzata una modalità)
				if @page.is_static?
					ricerca_statica
				else
					ricerca_dinamica
				end
		end
	end

	def ricerca_statica
		# nella ricerca statica viene effettuata una sola ricerca (la prima)
		#todo: pensare se esiste un tipo di dato migliore per rappresentare il risultato della ricerca statica
		#todo: si può introdurre un ciclo per fare più ricerche consecutive (il risultato però sarà sempre solo la prima pagina)
		static_search = StaticExtractor.new(@page, @lista_campi_dati[0], @lista_dropdown[0])
		# 'ris' è una STRINGA rappresentante una singola pagina HTML
		ris        = static_search.avvia_ricerca
		# il risultato della ricerca prevede una chiave 'mode' che da indicazioni sul metodo che è stato utilizzato
		@risultato = { pagine: ris, mode: :static }
	end

	def ricerca_dinamica
		# se il driver non è stato passato come parametro alla creazione dell'istanza di BeautiForm lo creo io
		if @driver == nil
			### apertura del driver ###
			if @esecuzione_silenziosa
				@headless = Headless.new
				@headless.start
			end
			must_quit_driver = true
			@driver          = Selenium::WebDriver.for :firefox
			@driver.navigate.to @url
			###########################
		end
		dynamic_search = DynamicExtractor.new(@driver, @next_xpath, @marker_fine_pagina, @lista_campi_dati, @lista_dropdown)
		# 'ris' è una MATRICE (simulata con HASH) rappresentante più ricerche con più pagine
		ris = dynamic_search.avvia_ricerca

		### chiusura del driver ###
		@driver.quit if must_quit_driver
		@headless.destroy unless @headless.nil?
		###########################

		# il risultato della ricerca prevede una chiave 'mode' che da indicazioni sul metodo che è stato utilizzato
		@risultato = { pagine: ris, mode: :dynamic }
	end

	def salva_su_file(pagine)
		# ricerca statica
		if pagine.class == String
			File.open($dir.to_s + 'file_r_static' + '.html', 'w') do |scrivi|
				scrivi << pagine
			end
			# ricerca dinamica
		elsif pagine.class == Hash
			pagine.each { |coordinate, html_source| # coordinate è un array [x,y]
				numero_ricerca = coordinate[0] # x
				numero_pagina  = coordinate[1] # y
				File.open($dir.to_s + 'file_r' + numero_ricerca.to_s + 'p' + numero_pagina.to_s + '.html', 'w') do |scrivi|
					scrivi << html_source
				end
			}
		end
	end
end
