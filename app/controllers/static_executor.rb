require '../../app/controllers/static_solver'
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


page          = StaticSolver.new(url, xpath)


##############################################################################
##############################################################################

# static = page.is_static?
# static = site.is_static? './/*[@id="search"]'

# site = StaticSolver.new 'http://www.amazon.it'
# static = site.is_static? './/*[@id="twotabsearchtextbox"]'


# puts page.form, page.input, page.method, page.on_submit

# puts page.input
# puts '----------'
# puts page.input[0].keys
#

# puts page.get_element_by_xpath './/*[@id="searchField"]'


lista_campi_dati = { xpath => 'ati radeon' }
# lista_campi_dati = {'//*[@id="searchField"]' => 'Verdi'}

static_search = StaticExtractor.new(page, lista_campi_dati)
puts p = static_search.pagina_risultato

File.open('prova.html', 'w') do |scrivi|
	scrivi << p
end


# puts '*** static? ' + static.to_s + ' ***'


# puts site.get_form('.//*[@id="searchField"]').to_s