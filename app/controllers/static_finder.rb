require 'httparty'
require 'nokogiri'
require 'open-uri'

class StaticFinder
  $dir = '/home/leinad/RubymineProjects/ruby_bot/bot_testing/'

  def initialize (url)
    @doc = Nokogiri::XML(open(url))
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
    if blocco[0].name == 'form' # blocco[0].class = Nokogiri::XML::Element
      blocco # blocco.class = Nokogiri::XML::NodeSet
    else
      get_form ("#{xpath}/..")
    end
  end


  def is_static?(campo_dati_xpath)
    form = get_form(campo_dati_xpath)
    puts form_xpath = form[0].path

    method = form[0]['method']
    on_submit = form[0]['onsubmit']
    # input = @doc.xpath("#{form_xpath}/input")
    input = @doc.xpath("#{form_xpath}//*[name() = 'input']") # equivale alla riga precendente ma così scritto
    # funziona anche con documenti xhtml
    puts "Numero di elementi <input> trovati: #{input.length}"
    # @static = -1

    # ATTENZIONE: il submit potrebbe non essere sul primo sottolivello del form, ma anche in livelli successivi
    # inoltre posso avere anche più elementi input per cui devo controllare in tutti gli input[i]

    puts 'FORM'
    puts form.to_s
    puts 'METHOD'
    puts method.to_s
    puts 'INPUT'
    input.each do |elemento|
      if elemento['type'] == 'submit' || elemento['type'] == 'image'
        on_submit.nil? ? @static = true : @static = false
      else
        @static = false
      end
      puts elemento.to_s
    end
    return @static
  end


  # @return [Array] pagine_risultato
  def avvia_ricerca

  end

  def click(button)

  end

  def wait_page_load

  end

  def set_next_button(next_xpath)

  end

  def displayed?(locator)

  end

  def errore(e)
    puts "catturata eccezione: #{e} : #{e.backtrace.inspect}"
  end
end