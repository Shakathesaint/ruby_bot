require 'rspec'
require_relative '../app/controllers/page_analyzer'


describe PageAnalyzer do

	describe '#inizialize' do

		context 'given a valid URL and XPATH' do
			it 'crea una nuova istanza di un oggetto Nokogiri' do
				url   = 'https://it.yahoo.com/'
				xpath = './/*[@id=\'p_13838465-p\']'
				expect { PageAnalyzer.new(url, xpath) }.to_not raise_exception
			end
		end

		context 'not given a valid URL' do
			it 'lancia una eccezione durante la creazione di una nuova istanza di un oggetto Nokogiri' do
				url   = 'NOT_VALID_URL://it.yahoo.com/'
				xpath = './/*[@id=\'p_13838465-p\']'
				expect { PageAnalyzer.new(url, xpath) }.to raise_exception Errno::ENOENT
			end
		end

		context 'not given a valid field XPATH for the URL' do
			it 'crea una nuova istanza di un oggetto Nokogiri' do
				url   = 'https://it.yahoo.com/'
				xpath = 'NOT_VALID_XPATH'
				expect { PageAnalyzer.new(url, xpath) }.to raise_exception RuntimeError
			end
		end
	end

	describe 'is_static?' do
		context 'given the URL of a static form' do
			it 'ritorna true' do
				url    = 'http://www.amazon.it'
				xpath  = '//*[@id="twotabsearchtextbox"]'
				page   = PageAnalyzer.new url, xpath
				static = page.is_static?
				static.should be true
			end
		end
		context 'given the URL of a dynamic form' do
			it 'ritorna true' do
				url    = 'http://www.paginebianche.it'
				xpath  = './/*[@id="input_cosa"]'
				page   = PageAnalyzer.new url, xpath
				static = page.is_static?
				static.should be false
			end
		end
	end
end
