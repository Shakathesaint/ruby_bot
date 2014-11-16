class StaticExtractor

  #todo: per il momento passiamo direttamente questi valori, successivamente verranno estratti e passati dalla superclasse che gestisce statico/dinamico
  def initialize (static_solver, url, lista_campi_dati)
    @page = static_solver
    @url = url
    # @campi_dati_html ha un hash:    <input... > in html
    #                        valore:  stringa di ricerca da inserire nell'input
    @campi_dati_html = xpath_to_html lista_campi_dati
  end

  # devo ricavarmi i campi dati (xpath e testo) da inserire nella richiesta e dividere get e post
  # tramite get_element_by_xpath() prendo ad uno ad uno le key di campi_dati e analizzo gli input in html


  #
  # prende un hash deve le key sono xpath e restituisce un hash dove le key sono il codice html corrispondente a quell'xpath
  #
  def xpath_to_html(campi_dati_xpath)
    campi_dati_html = Hash.new
    campi_dati_xpath.each do |key, value|
      elem_xpath = key
      campi_dati_html[@page.get_element_by_xpath elem_xpath] = value
    end
    return campi_dati_html
  end

end