=begin

E' la classe che si interfaccia col mondo esterno:

1) riceve i dati in ingresso sotto forma di file .json
2) decide a quale metodo affidare la ricerca: statico o dinamico (affidandosi a PageAnalyser)
3) crea dal file .json delle strutture compatibili con le due sottoclassi
		(è necessario spostare tutte le funzioni di lettura del file .json dalla classe dinamica a questa)

=end

$dir = '/home/leinad/RubymineProjects/ruby_bot/bot_testing/'

class BeautiForm
	attr_reader :risultato
	require 'selenium-webdriver'
	require 'json'
	require '../../app/controllers/page_analyzer'
	require '../../app/controllers/static_extractor'
	require '../../app/controllers/dynamic_extractor'

	# @param [Hash] options import: [percorso del file .json da importare]; force: forza modalità 'static' o 'dynamic'; driver: [passa un driver di Selenium preesistente]
	def initialize(options = {})
		# def initialize(url, nomefile_json = "#{$dir}struttura_dati.json", mode = nil)
		nomefile_json = options[:import] ||= "#{$dir}struttura_dati.json"
		# mode può assumere i valori {force: static} o {force: dynamic},
		# se lasciato vuoto viene deciso in automatico se lanciare una ricerca statica o dinamica
		mode          = options[:force] ||= nil
		# il driver può essere passato come parametro alla classe o creato dal metodo ricerca_dinamica
		@driver = options[:driver] ||= nil

		File.open(nomefile_json, 'r') do |leggi|
			@struttura_dati = JSON.parse(leggi.gets) # gets legge una stringa dal file
		end

		@url = @struttura_dati['url']

		#todo: chiedere se posso generare io il driver di Selenium, sembra una scelta più logica in quanto andrebbe creato solo se la ricerca è DINAMICA

		################  USATE SOLO DALLA RICERCA DINAMICA  #######################################################
		@next_xpath         = @struttura_dati['next_xpath']
		# @marker_fine_pagina deve essere un elemento che garantisce che la pagina sia stata caricata completamente.
		# Non esiste infatti in Selenium un metodo per garantire che una pagina abbia completato il caricamento
		# è consigliato di evitare un elemento funzionalmente collegato alla ricerca perché potrebbe non apparire
		# nella pagina qualora la ricerca non dia risultati o dia risultati di una sola pagina
		@marker_fine_pagina = @struttura_dati['marker_fine_pagina']
		############################################################################################################

		@lista_campi_dati   = []
		@lista_dropdown     = []

		ricerche = @struttura_dati['ricerche'] #array
		ricerche.each do |ricerca|
			@lista_campi_dati << ricerca[0]
			@lista_dropdown << ricerca[1]
		end

		#todo non è vero che viene usato solo dalla ricerca statica: implementare per ricerca dinamica
		################  USATA SOLO DALLA RICERCA STATICA  ########################################################
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
			when 'static'
				ricerca_statica
			when 'dynamic'
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
		r          = static_search.avvia_ricerca # è una stringa rappresentante una singola pagina HTML
		# il risultato della ricerca prevede una chiave 'mode' che da indicazioni sul metodo che è stato utilizzato
		@risultato = { pagine: r, mode: :static }
	end

	def ricerca_dinamica
		# se il driver non è stato passato come parametro alla creazione dell'istanza di BeautiForm lo creo io
		if @driver == nil
			must_quit_driver = true
			@driver          = Selenium::WebDriver.for :firefox
			@driver.navigate.to @url
		end
		dynamic_search = DynamicExtractor.new(@driver, @next_xpath, @marker_fine_pagina, @lista_campi_dati)
		r              = dynamic_search.avvia_ricerca # è una matrice (simulata con hash) rappresentante più ricerche con più pagine
		@driver.quit if must_quit_driver
		# il risultato della ricerca prevede una chiave 'mode' che da indicazioni sul metodo che è stato utilizzato
		@risultato = { pagine: r, mode: :dynamic }
	end
end