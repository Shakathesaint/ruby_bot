require 'rspec'
require_relative '../app/controllers/driver_generator'
require_relative '../app/controllers/html_extractor'

describe HtmlExtractor do
  before(:each) do
    @stub_dati = DriverGenerator.new
  end
  after(:each) do
    @stub_dati.driver.quit
  end

  describe '#inizialize' do

    context 'given a valid .json file' do

      it 'crea @struttura_dati coerente con il file .json passato come parametro' do
        #############################################
        # crea una struttura dati con DriverGenerator
        next_xpath = '//*[@title="Vai alla pagina successiva"]'
        page_loaded_xpath = '//*[@id="pager"]'
        r1 = {'//*[@id="searchField"]' => 'Bianchi'}
        r2 = {'//*[@id="searchField"]' => 'Verdi'}
        @stub_dati.next_xpath = next_xpath
        @stub_dati.page_loaded_xpath = page_loaded_xpath
        @stub_dati.add_ricerca r1
        @stub_dati.add_ricerca r2
        @stub_dati.to_file_json test1 = 'test1.json'
        #############################################
        extr = HtmlExtractor.new(@stub_dati.driver, test1)

        extr.struttura_dati[0].should be == next_xpath
        extr.struttura_dati[1].should be == page_loaded_xpath
        extr.lista_campi_dati[0].should be == {"//*[@id=\"searchField\"]" => "Bianchi"}
        extr.lista_campi_dati[1].should be == {"//*[@id=\"searchField\"]" => "Verdi"}
      end

    end

  end

  describe '#avvia_ricerca' do

    context 'given an Amazon search request' do

      it 'esegue una ricerca multipla su Amazon' do
        next_xpath = '//*[@id="pagnNextLink"]' # xpath del tasto next
        page_loaded_xpath = '//*[@id="pagnNextString"]' # marker di fine pagina - garantisce che la pagina ha terminato il caricamento
        r1 = {'//*[@id="twotabsearchtextbox"]' => 'asus g750jx'}
        r2 = {'//*[@id="twotabsearchtextbox"]' => 'isaac asimov'}
        site = 'http://www.amazon.it/'

        @stub_dati.next_xpath = next_xpath
        @stub_dati.page_loaded_xpath = page_loaded_xpath
        @stub_dati.add_ricerca r1
        @stub_dati.add_ricerca r2
        @stub_dati.to_file_json test1 = 'test1.json'
        @stub_dati.site = site

        extr = HtmlExtractor.new(@stub_dati.driver, test1)
        extr.avvia_ricerca
      end

    end

    context 'given an Fnovi search request' do

      it 'esegue una ricerca multipla su Fnovi' do
        next_xpath = '//*[@title="Vai alla pagina successiva"]' # xpath del tasto next
        page_loaded_xpath = '//*[@id="pager"]' # marker di fine pagina - garantisce che la pagina ha terminato il caricamento
        r1 = {'//*[@id="searchField"]' => 'Bianchi'}
        r2 = {'//*[@id="searchField"]' => 'Verdi'}
        site = 'http:/www.fnovi.it/index.php?pagina=ricerca-iscritti'

        @stub_dati.next_xpath = next_xpath
        @stub_dati.page_loaded_xpath = page_loaded_xpath
        @stub_dati.add_ricerca r1
        @stub_dati.add_ricerca r2
        @stub_dati.to_file_json test1 = 'test1.json'
        @stub_dati.site = site

        extr = HtmlExtractor.new(@stub_dati.driver, test1)
        extr.avvia_ricerca
      end

    end

    context 'given an PagineBianche search request' do

      it 'esegue una ricerca multipla su PagineBianche' do
        next_xpath = '//*[@class="listing-pag-n listing-pag-succ"]' # xpath del tasto next
        page_loaded_xpath = '//*[@id="container"]/div[4]' # marker di fine pagina - garantisce che la pagina ha terminato il caricamento
        r1 = {:'//*[@id="input_cosa"]' => 'De Amicis', :'//*[@id="input_dove"]' => 'Roma'}
        r2 = {:'//*[@id="input_cosa"]' => 'Bonucci', :'//*[@id="input_dove"]' => 'Roma'}
        site = 'http://www.paginebianche.it/'

        @stub_dati.next_xpath = next_xpath
        @stub_dati.page_loaded_xpath = page_loaded_xpath
        @stub_dati.add_ricerca r1
        @stub_dati.add_ricerca r2
        @stub_dati.to_file_json test1 = 'test1.json'
        @stub_dati.site = site

        extr = HtmlExtractor.new(@stub_dati.driver, test1)
        extr.avvia_ricerca
      end

    end
  end

  describe '#click' do

  end

  describe '#wait_page_load' do

  end

  describe '#set_next_button' do

  end

  describe '#displayed?' do

  end


end