require 'rspec'

require_relative '../app/controllers/client_simulator'
require_relative '../app/controllers/static_extractor'
require_relative '../app/controllers/beauti_form'

describe StaticExtractor do

	describe '#compila_parametri' do
		xit 'should do something' do
		end
	end

	describe '#avvia_ricerca' do
		context 'given an Amazon search request' do
			before(:each) do
				next_xpath        = '//*[@id="pagnNextLink"]' # xpath del tasto next
				page_loaded_xpath = '//*[@id="pagnNextString"]' # marker di fine pagina - garantisce che la pagina ha terminato il caricamento
				r1                = { '//*[@id="twotabsearchtextbox"]' => 'asus g750jx' }

				@client                   = ClientSimulator.new 'http://www.amazon.it/'
				@client.next_xpath        = next_xpath
				@client.page_loaded_xpath = page_loaded_xpath
				@client.add_ricerca r1
			end

			it 'esegue una ricerca singola su Amazon' do
				@client.to_file_json

				seeker = BeautiForm.new force: 'static'
				pagine = seeker.risultato[:pagine]
				# seeker.salva_su_file pagine
				mode   = seeker.risultato[:mode]
				pagine.should_not be_nil
				pagine.size.should be > 10 # una pagina HTML si presume abbia più di 10 byte/caratteri
				mode.should be == :static
			end
		end

		context 'given a Fnovi search request' do
			before(:each) do
				next_xpath        = '//*[@title="Vai alla pagina successiva"]' # xpath del tasto next
				page_loaded_xpath = '//*[@id="pager"]' # marker di fine pagina - garantisce che la pagina ha terminato il caricamento
				r1                = { '//*[@id="searchField"]' => 'Bianchi' }

				@client                   = ClientSimulator.new 'http://www.fnovi.it/index.php?pagina=ricerca-iscritti'
				@client.next_xpath        = next_xpath
				@client.page_loaded_xpath = page_loaded_xpath
				@client.add_ricerca r1
			end

			it 'esegue una ricerca singola su Fnovi' do
				@client.to_file_json

				seeker = BeautiForm.new force: 'static'
				pagine = seeker.risultato[:pagine]
				# seeker.salva_su_file pagine
				mode   = seeker.risultato[:mode]
				pagine.should_not be_nil
				pagine.size.should be > 10 # una pagina HTML si presume abbia più di 10 byte/caratteri
				mode.should be == :static
			end
		end

		describe '#xpath_to_html' do
			xit 'should do something' do
			end
		end
	end
end
