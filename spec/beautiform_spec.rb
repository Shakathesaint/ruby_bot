require 'rspec'

require_relative '../app/controllers/client_simulator'
require_relative '../app/controllers/beauti_form'

describe BeautiForm do

	describe '#inizialize' do
		before(:all) do
			@next_xpath        = '//*[@id="pagnNextLink"]' # xpath del tasto next
			@page_loaded_xpath = '//*[@id="pagnNextString"]' # marker di fine pagina - garantisce che la pagina ha terminato il caricamento
			@r1                = { '//*[@id="twotabsearchtextbox"]' => 'asus g750jx' }
			@r2                = { '//*[@id="twotabsearchtextbox"]' => 'asus g750jz' }
			@drop1             = { '//*[@id="searchDropdownBox"]' => 'Abbigliamento' }

			@client                   = ClientSimulator.new 'http://www.amazon.it/'
			@client.next_xpath        = @next_xpath
			@client.page_loaded_xpath = @page_loaded_xpath
			@client.add_ricerca @r1, @drop1
			@client.add_ricerca @r2
			@client.to_file_json

			@seeker = BeautiForm.new
		end
		context 'given a valid .json file' do
			it 'crea una struttura dati coerente con il file .json passato come parametro' do
				@seeker.next_xpath.should be == @next_xpath
				@seeker.marker_fine_pagina.should be == @page_loaded_xpath

				@seeker.lista_campi_dati[0].should be == @r1
				@seeker.lista_campi_dati[1].should be == @r2
				@seeker.lista_campi_dati[2].should be_nil

				@seeker.lista_dropdown[0].should be == @drop1
				@seeker.lista_dropdown[1].should be_nil
			end
		end
	end
end
