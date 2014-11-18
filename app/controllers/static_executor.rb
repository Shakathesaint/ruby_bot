require '../../app/controllers/static_solver'
require '../../app/controllers/static_extractor'

##############################################################################
###########       SITI DI TEST       #########################################

# attenzione: l'xpath deve sempre iniziare con './/'

# url = 'http://www.fnovi.it/index.php?pagina=ricerca-iscritti'
# page = StaticSolver.new(url, './/*[@id="searchField"]')

# url = 'http://www.vanbasco.com/it'
# page = StaticSolver.new(url, './/input[@name="q"]')

url = 'http://torrentz.eu'
page = StaticSolver.new(url, './/input[@name="q"]')

##############################################################################
##############################################################################

# static = page.is_static?

# site = StaticSolver.new 'http://www.amazon.it'
# static = site.is_static? './/*[@id="twotabsearchtextbox"]'

#todo: perché un form XHTML non ha l'attributo method?
# site = StaticSolver.new 'http://www.protezionecivile.gov.it/jcms/it/elenco_centrale_delle_org.wp'
# static = site.is_static? './/*[@id="search"]'


# puts page.form, page.input, page.method, page.on_submit

# puts page.input
# puts '----------'
# puts page.input[0].keys
#

# puts page.get_element_by_xpath './/*[@id="searchField"]'


lista_campi_dati = {'.//input[@name="q"]' => 'Vasco Rossi'}
# lista_campi_dati = {'//*[@id="searchField"]' => 'Verdi'}

static_search = StaticExtractor.new(page, lista_campi_dati)
puts p = static_search.pagina_risultato

File.open('prova.html', 'w') do |scrivi|
  scrivi << p
end


# puts '*** static? ' + static.to_s + ' ***'


# puts site.get_form('.//*[@id="searchField"]').to_s