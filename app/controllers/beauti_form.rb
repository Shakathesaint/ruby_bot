=begin

E' la classe che si interfaccia col mondo esterno:

1) riceve i dati in ingresso sotto forma di file .json
2) decide a quale metodo affidare la ricerca: statico o dinamico (affidandosi a PageAnalyser)
3) crea dal file .json delle strutture compatibili con le due sottoclassi
		(è necessario spostare tutte le funzioni di lettura del file .json dalla classe dinamica a questa)

=end

$dir = '/home/leinad/RubymineProjects/ruby_bot/bot_testing/'

class BeautiForm

	#todo: chiedere se posso generare io il driver di Selenium, sembra una scelta più logica in quanto andrebbe creato solo se la ricerca è DINAMICA
	# @param [String] url pagina iniziale della ricerca
	# @param [String] nomefile_json
	def initialize(url, nomefile_json = "#{$dir}struttura_dati.json")
		File.open(nomefile_json, 'r') do |leggi|
			@struttura_dati = JSON.parse(leggi.gets) # gets legge una stringa dal file
		end

		################  USATE SOLO DALLA RICERCA DINAMICA  #######################################################
		next_xpath         = @struttura_dati[0]
		# @marker_fine_pagina deve essere un elemento che garantisce che la pagina sia stata caricata completamente.
		# Non esiste infatti in Selenium un metodo per garantire che una pagina abbia completato il caricamento
		# è consigliato di evitare un elemento funzionalmente collegato alla ricerca perché potrebbe non apparire
		# nella pagina qualora la ricerca non dia risultati o dia risultati di una sola pagina
		marker_fine_pagina = @struttura_dati[1]
		############################################################################################################

		lista_campi_dati   = @struttura_dati[2]

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

		if @struttura_dati[3].nil?
			lista_dropdown = nil
		else
			lista_dropdown = @struttura_dati[3]
		end
		############################################################################################################

		xpath_primo_campo = lista_campi_dati.keys[0]

		page = PageAnalyzer.new(url, xpath_primo_campo)

		if page.is_static?
			# lancia ricerca statica
			static_search = StaticExtractor.new(page, lista_campi_dati, lista_dropdown)
			@risultato    = static_search.avvia_ricerca # è una stringa rappresentante una singola pagina HTML
		else
			# lancia ricerca dinamica
			dynamic_search = DynamicExtractor.new(driver, next_xpath, marker_fine_pagina, lista_campi_dati)
			@risultato     = dynamic_search.avvia_ricerca # è una matrice rappresentante più ricerche con più pagine
		end


	end

end