require 'httparty'
require 'nokogiri'
require 'open-uri'

class StaticExtractor
  $dir = '/home/leinad/RubymineProjects/ruby_bot/bot_testing/'

  def initialize #(driver, nomefile_json = "#{$dir}struttura_dati.json")
    @form_xpath = ".//form"
    @doc = Nokogiri::HTML(open("http://www.fnovi.it/index.php?pagina=ricerca-iscritti"))
    # @doc = Nokogiri::HTML(open("http://www.serabright.com/mailing-list-sign-up.html"))
    # puts form = @doc.xpath(@form_xpath)
    # puts ' =================== '
    # # puts form.length
    # puts form[0]["type"]
    # # puts temp
  end

  # @return [Array] pagine_risultato
  def avvia_ricerca

  end

  def is_static?
    form = @doc.xpath(@form_xpath)
    method = form[0]["method"]
    on_submit = form[0]["onsubmit"]
    input = @doc.xpath("#{@form_xpath}/input")

    # ATTENZIONE: il submit potrebbe non essere sul primo sottolivello del form, ma anche in livelli successivi
    # inoltre posso avere anche più elementi input per cui devo controllare in tutti gli input[i]
    if (input[0]["type"] == 'submit' || input[0]["type"] == 'image')
      on_submit.nil? ? static = true : static = false
    else
      static = false
    end
    puts 'FORM'
    puts form.to_s
    puts 'METHOD'
    puts method.to_s
    puts 'INPUT'
    puts input.to_s
    return static
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