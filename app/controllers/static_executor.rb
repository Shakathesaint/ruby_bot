require '../../app/controllers/static_solver'

form = StaticSolver.new 'http://www.fnovi.it/index.php?pagina=ricerca-iscritti'
static = form.is_static? './/*[@id="searchField"]'

# site = StaticSolver.new 'http://www.amazon.it'
# static = site.is_static? './/*[@id="twotabsearchtextbox"]'

#todo: perché un form XHTML non ha l'attributo method?
# site = StaticSolver.new 'http://www.protezionecivile.gov.it/jcms/it/elenco_centrale_delle_org.wp'
# static = site.is_static? './/*[@id="search"]'


puts '*** static? ' + static.to_s + ' ***'


# puts site.get_form('.//*[@id="searchField"]').to_s