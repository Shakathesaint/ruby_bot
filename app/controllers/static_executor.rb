require '../../app/controllers/static_solver'
require '../../app/controllers/static_extractor'

page = StaticSolver.new('http://www.fnovi.it/index.php?pagina=ricerca-iscritti', './/*[@id="searchField"]')
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


lista_campi_dati = {'//*[@id="searchField"]' => 'Bianchi'}

static_search = StaticExtractor.new(page, 'http://www.fnovi.it/index.php?pagina=ricerca-iscritti', lista_campi_dati)


# puts '*** static? ' + static.to_s + ' ***'


# puts site.get_form('.//*[@id="searchField"]').to_s