require 'nokogiri'
require 'open-uri'

class StaticSolver
$dir = '/home/leinad/RubymineProjects/ruby_bot/bot_testing/'

attr_reader :form, :method, :input, :on_submit, :action, :url


def initialize (url, campo_dati_xpath)
  @url = url
  @doc = Nokogiri::HTML(open(url))

    @form = get_form(campo_dati_xpath)
    puts form_xpath = form[0].path

    @method = @form[0]['method']
    @action = @form[0]['action']
    @on_submit = @form[0]['onsubmit']

  # ATTENZIONE: in generale avrò più elementi <input...> nella form e devo analizzarli tutti per trovare il submit
  # il metodo usato qui sotto consiste nell'aggiungere '/input' all'xpath del form e funziona correttamente;
  # se usassi invece:
  # - get_element_by_xpath(campo_dati_xpath)
  # mi restituirebbe un solo <input...> corrispondente all'xpath del campo dati passato

  @input = @doc.xpath("#{form_xpath}//*[name() = 'input']")
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
    pippo = blocco[0]
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
  # @return [Nokogiri::XML::NodeSet] blocco è l'oggetto corrispondente all'xpath
  def get_element_by_xpath(xpath)
    # restituisco l'elemento corrispondente - nota: a priori un xpath non è univoco, per questo
    # in realtà blocco[] è un array di risultati
    @doc.xpath(xpath)
  end


  def is_static?

    # ATTENZIONE: il submit potrebbe non essere sul primo sottolivello del form, ma anche in livelli successivi
    # inoltre posso avere anche più elementi input per cui devo controllare in tutti gli input[i]

    @input.each do |elemento|
      if elemento['type'] == 'submit' || elemento['type'] == 'image'
        @on_submit.nil? ? @static = true : @static = false
      else
        @static = false
      end
      # puts elemento.to_s
    end
    return @static
  end

  def errore(e)
    puts "catturata eccezione: #{e} : #{e.backtrace.inspect}"
  end
end