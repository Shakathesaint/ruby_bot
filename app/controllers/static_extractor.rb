require 'httparty'
require 'nokogiri'
require 'open-uri'

class StaticExtractor
  $dir = '/home/leinad/RubymineProjects/ruby_bot/bot_testing/'

  def initialize (url)
    #todo: cancellare @form_xpath e prendere il valore da get_form
    @form_xpath = './/form'
    @doc = Nokogiri::HTML(open(url))
  end

  #
  # prende l'xpath del primo campo dati e risale al form che lo contiene
  #
  # @param [String] campo_dati
  def get_form (campo_dati_xpath)
    # risalgo al form di appartenenza
    blocco = @doc.xpath(campo_dati_xpath)
    #chiamata ricorsiva
    if blocco[0].name == 'form'
      blocco[0]
    else
      get_form ("#{campo_dati_xpath}/..")
    end
  end


  def is_static?
    form = @doc.xpath(@form_xpath)
    method = form[0]['method']
    on_submit = form[0]['onsubmit']
    input = @doc.xpath("#{@form_xpath}/input")
    @static = -1

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