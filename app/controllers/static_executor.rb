require '../../app/controllers/page_analyzer'
require '../../app/controllers/static_extractor'

##############################################################################
###########       SITI DI TEST       #########################################

# attenzione: l'xpath deve sempre iniziare con './/'

# url = 'http://www.fnovi.it/index.php?pagina=ricerca-iscritti'
# xpath = './/*[@id="searchField"]'

# url = 'http://www.vanbasco.com/it'
# xpath = './/input[@name="q"]'

# url = 'http://torrentz.eu'
# xpath = './/input[@name="q"]'

# url = 'http://www.protezionecivile.gov.it/jcms/it/elenco_centrale_delle_org.wp'
# xpath = './/*[@id="search"]'


url   = 'http://www.amazon.it'
xpath = './/*[@id="twotabsearchtextbox"]'


page = PageAnalyzer.new(url, xpath)


##############################################################################
##############################################################################

# static = page.is_static?
# static = site.is_static? './/*[@id="search"]'

# site = PageAnalyzer.new 'http://www.amazon.it'
# static = site.is_static? './/*[@id="twotabsearchtextbox"]'


# puts page.form, page.input, page.method, page.on_submit

# puts page.input
# puts '----------'
# puts page.input[0].keys

##############################################################################




lista_dropdown = { './/*[@id="searchDropdownBox"]' => '' }
lista_campi_dati = { xpath => 'ati radeon' }

static_search = StaticExtractor.new(page, lista_campi_dati, lista_dropdown)
puts p = static_search.pagina_risultato

File.open('prova.html', 'w') do |scrivi|
	scrivi << p
end


# puts '*** static? ' + static.to_s + ' ***'


# puts site.get_form('.//*[@id="searchField"]').to_s