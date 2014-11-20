class ClientSimulator
	require 'selenium-webdriver'
	require 'json'

	def initialize(url_ricerca)
		@struttura_dati            = Hash.new
		@struttura_dati[:url]      = url_ricerca
		@struttura_dati[:ricerche] = []
	end

	# @param [String] dati - nome del file .json da creare (opzionale)
	def to_file_json (dati = "#{$dir}struttura_dati.json")
		File.open(dati, 'w') do |scrivi|
			scrivi << @struttura_dati.to_json
		end
		puts Dir.pwd
	end

	###############
	# metodi SETTER
	###############

	# @param [String] xpath
	def next_xpath=(xpath)
		@struttura_dati[:next_xpath] = xpath
	end

	# @param [String] xpath
	def page_loaded_xpath=(xpath)
		@struttura_dati[:marker_fine_pagina] = xpath
	end

	# @param [Hash] campi_dati
	# @param [Hash] campi_dropdown
	def add_ricerca(campi_dati, campi_dropdown = nil)
		@struttura_dati[:ricerche] << [campi_dati, campi_dropdown]
	end


	###############
	# metodi GETTER
	###############

	# attr_reader :driver, :strutturaDati
	# non posso usare attr_reader perché mi restituisce una STRINGA corrispondente ai valori e non l'oggetto
	# mi devo perciò definire i miei metodi getter
end