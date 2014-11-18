require 'httparty'

class StaticExtractor
  attr_reader :pagina_risultato
  include HTTParty

  #todo: per il momento passiamo direttamente questi valori, successivamente verranno estratti e passati dalla superclasse che gestisce statico/dinamico
  def initialize (static_solver, lista_campi_dati)
    @page = static_solver
    @action_url = static_solver.action # attributo 'action' dell'elemento <input>: contiene l'url della pagina cui inviare la GET/POST
    # alcune pagine hanno una 'action' con un url parziale, in quel caso richiamiamo il metodo base_uri di HTTParty
    # che setta un url di base cui viene 'appesa' la stringa contenuta nell'action
    unless @action_url.include? 'http://' # unless è un if negato
      #alcuni 'action' non cominciano per '/', in quel caso lo aggiungiamo
      unless @action_url[0] == '/'
        @action_url = '/' + @action_url
      end
      homepage_url = @page.url
      self.class.base_uri homepage_url
    end
    hidden_inputs = @page.get_hidden_inputs
    @options      = compila_parametri lista_campi_dati, hidden_inputs

    # @campi_dati_html = xpath_to_html lista_campi_dati

    risultato = avvia_ricerca
    @pagina_risultato = risultato.to_s
  end

  #todo: aggiungere la gestione dei parametri per i menu a tendina
  def compila_parametri(lista_campi_visibili, lista_campi_hidden)
    # devo ricavarmi i campi dati (xpath e testo) da inserire nella richiesta e dividere get e post
    # tramite get_element_by_xpath() prendo ad uno ad uno le key di campi_dati e analizzo gli input in html
    parametri = Hash.new
    lista_campi_visibili.each do |xpath_input, testo_input|
      html_input = @page.get_element_by_xpath xpath_input # prendo l'<input ...> html relativo all'xpath fornito in ingresso
      nome_input = html_input[0]['name'] # mi ricavo il nome dell'input da inserire nella GET/POST
      parametri[nome_input] = testo_input
    end
    if lista_campi_hidden.size >= 1
      # lista_campi_hidden viene passata direttamente con coppie {nome => valore} perciò non va convertita da xpath
      # come per lista_campi_visibili
      parametri.merge!(lista_campi_hidden)
    end
    return {body: parametri} if is_post_method?
    return {query: parametri} # if is_get_method? ## se non c'è attributo 'method' lo consideriamo implicitamente una get
  end


  def is_get_method?
    @page.method.to_s.upcase == 'GET'
  end

  def is_post_method?
    @page.method.to_s.upcase == 'POST'
  end


  def avvia_ricerca

    if is_get_method?
      return self.class.get(@action_url, @options)
    elsif is_post_method?
      return self.class.post(@action_url, @options)
    else
      # se non è presente l'attributo 'method' solitamente è implicitamente una get
      puts 'attributo method non presente - tentativo di lanciare una get'
      return self.class.get(@action_url, @options)
    end

  end


  #
  # prende un hash deve le key sono xpath e restituisce un hash dove le key sono il codice html corrispondente a quell'xpath
  #
  def xpath_to_html(campi_dati_xpath)
    # campi_dati_html ha un hash:    <input... > in html
    #                       valore:  stringa di ricerca da inserire nell'input
    campi_dati_html = Hash.new
    campi_dati_xpath.each do |key, value|
      elem_xpath = key
      campi_dati_html[@page.get_element_by_xpath elem_xpath] = value
    end
    return campi_dati_html
  end

end