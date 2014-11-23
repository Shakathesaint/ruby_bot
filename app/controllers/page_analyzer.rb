require 'nokogiri'
require 'open-uri'

class PageAnalyzer
	# $dir = '/home/leinad/RubymineProjects/ruby_bot/bot_testing/'

	attr_reader :form, :method, :input, :on_submit, :action, :url, :on_click


	def initialize (url, campo_dati_xpath)
		@url = url
		begin
			@doc = Nokogiri::HTML(open(url))
		rescue => e
			puts "URL richiesto mal formato -- #{e}"
			raise
		end

		@form      = get_form(campo_dati_xpath)
		form_xpath = form[0].path

		@method    = @form[0]['method']

		#todo: creare un test per verificare il caso di un attributo action nullo o stringa vuota
		# l'action vuoto semplicemente invia la GET/POST all'indirizzo della pagina attuale, quindi teoricamente
		# dovrebbe poter essere anche statico
		@action    = @form[0]['action']
		@on_submit = @form[0]['onsubmit']
		@on_click  = @form[0]['onclick']

		# ATTENZIONE: in generale avrò più elementi <input...> nella form e devo analizzarli tutti per trovare il submit
		# il metodo usato qui sotto consiste nell'aggiungere '/input' all'xpath del form e funziona correttamente;
		# se usassi invece:
		# - get_element_by_xpath(campo_dati_xpath)
		# mi restituirebbe un solo <input...> corrispondente all'xpath del campo dati passato

		@input     = @doc.xpath("#{form_xpath}//*[name() = 'input']")
		# equivale a:
		# input = @doc.xpath("#{form_xpath}/input")
		# ma così scritto funziona anche con documenti xhtml

		puts "Numero di elementi <input> trovati: #{@input.length}"
	end


#
# prende l'xpath di un elemento e risale al form che lo contiene
#
# @param [String] xpath
# @return [Nokogiri::XML::NodeSet] blocco è l'oggetto che racchiude la form
	def get_form (xpath)
		# risalgo al form di appartenenza - nota: a priori un xpath non è univoco, per questo
		# in realtà blocco[] è un array di risultati
		blocco = @doc.xpath(xpath)
		#chiamata ricorsiva
		if blocco[0].nil?
			raise Nokogiri::XML::SyntaxError, 'L\'xpath del primo campo dati contiene errori di sintassi (non è un xpath valido)'
		end
		if blocco[0].name == 'form' # blocco[0].class = Nokogiri::XML::Element
			blocco # blocco.class = Nokogiri::XML::NodeSet
		else
			get_form ("#{xpath}/..")
		end
	end


#
# prende l'xpath di un elemento e risale all'elemento corrispondente
#
# @param [String] xpath
# @return [Nokogiri::XML::NodeSet] l'oggetto corrispondente all'xpath
	def get_element_by_xpath(xpath)
		# restituisco l'elemento corrispondente - nota: a priori un xpath non è univoco, per questo
		# in realtà blocco[] è un array di risultati
		@doc.xpath(xpath)
	end

#
# restituisce un hash contenente nome e valore di tutti gli input con type='hidden' del form
#	le coppie sono STRINGHE di tipo {nome => valore}
#
# restituisce nil se non ci sono campi 'hidden'
#
# @return [Hash] hidden_inputs
	def get_hidden_inputs
		hidden_inputs = Hash.new
		@input.each do |elemento|
			if elemento['type'] == 'hidden'
				hidden_inputs[elemento['name']] = elemento['value']
			end
		end
		(hidden_inputs.size >= 1) ? hidden_inputs : nil
	end

	def is_static?

		# ATTENZIONE: il submit potrebbe non essere sul primo sottolivello del form, ma anche in livelli successivi
		# inoltre posso avere anche più elementi input per cui devo controllare in tutti gli input[i]

		if @on_submit.nil? and @on_click.nil?
			@input.each do |elemento|
				return @static = true if elemento['type'] == 'submit' || elemento['type'] == 'image'
			end
		else
			@static = false
		end
	end

	def errore(e)
		puts "catturata eccezione: #{e} : #{e.backtrace.inspect}"
	end
end