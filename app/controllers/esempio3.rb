require '../../app/controllers/client_simulator'
require '../../app/controllers/dynamic_extractor'
require '../../app/controllers/beauti_form'


client            = ClientSimulator.new 'http://www.paginebianche.it/'
client.next_xpath = '//*[@class="listing-pag-n listing-pag-succ"]'

r1 = { :'//*[@id="input_cosa"]' => 'De Amicis',
       :'//*[@id="input_dove"]' => 'Roma' }

# OPZIONALE
# client.page_loaded_xpath = '//*[@id="container"]/div[4]'


client.add_ricerca r1
client.to_file_json

seeker   = BeautiForm.new force: :dynamic
pagine   = seeker.risultato[:pagine]
modalita = seeker.risultato[:mode]

seeker.salva_su_file pagine

puts '====== CODICE HTML ======'
puts pagine

puts '====== MODALITA\' ========'
puts modalita