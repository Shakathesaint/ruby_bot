require '../../app/controllers/static_extractor'

site = StaticExtractor.new
static = site.is_static?

puts 'static? ' + static.to_s