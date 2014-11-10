require '../../app/controllers/static_extractor'

# site = StaticExtractor.new 'http://www.amazon.it'
site = StaticExtractor.new 'http://www.fnovi.it/index.php?pagina=ricerca-iscritti'

# static = site.is_static?
# puts 'static? ' + static.to_s


puts site.get_form('.//*[@id="searchField"]').to_s