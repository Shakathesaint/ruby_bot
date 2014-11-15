class StaticExtractor

  #todo: per il momento passiamo direttamente questi valori, successivamente verranno estratti e passati dalla superclasse che gestisce statico/dinamico
  def initialize (static_solver, url, campi_dati)
    @page = static_solver
    @url = url
    @campi = campi_dati
  end

  # devo ricavarmi i campi dati (xpath e testo) da inserire nella richiesta e dividere get e post

end