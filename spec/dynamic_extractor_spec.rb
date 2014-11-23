require 'rspec'
require 'headless'

require_relative '../app/controllers/client_simulator'
require_relative '../app/controllers/dynamic_extractor'
require_relative '../app/controllers/beauti_form'

describe DynamicExtractor do
  before(:each) do
    # @headless = Headless.new
    # @headless.start
  end
  after(:each) do
    # @headless.destroy
  end

  #todo: la verifica della correttezza del file .json va spostata tra i test di BeautiForm
  # describe '#inizialize' do
  #   before(:all) do
  #     client = ClientSimulator.new 'http://www.google.it'
  #   end
  # 
  #   context 'given a valid .json file' do
  # 
  #     it 'crea @struttura_dati coerente con il file .json passato come parametro' do
  #       #############################################
  #       # crea una struttura dati con ClientSimulator
  #       next_xpath = '//*[@title="Vai alla pagina successiva"]'
  #       page_loaded_xpath = '//*[@id="pager"]'
  #       client.next_xpath = next_xpath
  #       client.page_loaded_xpath = page_loaded_xpath
  #       r1 = {'//*[@id="searchField"]' => 'Bianchi'}
  #       d1 = {'//*[@id="ordine"]' => 'ROMA'}
  #       r2 = {'//*[@id="searchField"]' => 'Verdi'}
  #       client.add_ricerca r1, d1
  #       client.add_ricerca r2
  #       client.to_file_json
  #       #############################################
  #       
  #       driver = Selenium::WebDriver.for :firefox
  #       
  #       extr = DynamicExtractor.new driver, next_xpath, page_loaded_xpath, 
  # 
  #       extr.struttura_dati[0].should be == next_xpath
  #       extr.struttura_dati[1].should be == page_loaded_xpath
  #       extr.lista_campi_dati[0].should be == {"//*[@id=\"searchField\"]" => "Bianchi"}
  #       extr.lista_campi_dati[1].should be == {"//*[@id=\"searchField\"]" => "Verdi"}
  #     end
  # 
  #   end
  # 
  # end

  describe '#avvia_ricerca' do

    context 'given an Amazon search request' do
      before(:each) do
        next_xpath = '//*[@id="pagnNextLink"]' # xpath del tasto next
        page_loaded_xpath = '//*[@id="pagnNextString"]' # marker di fine pagina - garantisce che la pagina ha terminato il caricamento
        r1 = {'//*[@id="twotabsearchtextbox"]' => 'asus g750jx'}

        @client                   = ClientSimulator.new 'http://www.amazon.it/'
        @client.next_xpath        = next_xpath
        @client.page_loaded_xpath = page_loaded_xpath
        @client.add_ricerca r1
      end

      it 'esegue una ricerca singola su Amazon' do
        @client.to_file_json

        seeker = BeautiForm.new force: 'dynamic'
        pagine = seeker.risultato[:pagine]
        mode   = seeker.risultato[:mode]
        pagine[[0, 0]].should_not be_nil
        pagine[[1, 0]].should be_nil
        mode.should be == :dynamic
      end

      it 'esegue una ricerca multipla su Amazon' do
        r2 = {'//*[@id="twotabsearchtextbox"]' => 'asus g750jz'}
        @client.add_ricerca r2

        @client.to_file_json

        seeker = BeautiForm.new force: 'dynamic'
        pagine = seeker.risultato[:pagine]
        mode   = seeker.risultato[:mode]
        pagine[[0, 0]].should_not be_nil
        pagine[[1, 0]].should_not be_nil
        pagine[[2, 0]].should be_nil
        mode.should be == :dynamic
      end

    end

    context 'given a Fnovi search request' do
      before(:each) do
        next_xpath = '//*[@title="Vai alla pagina successiva"]' # xpath del tasto next
        page_loaded_xpath = '//*[@id="pager"]' # marker di fine pagina - garantisce che la pagina ha terminato il caricamento
        r1 = {'//*[@id="searchField"]' => 'Bianchi'}

        @client                   = ClientSimulator.new 'http://www.fnovi.it/index.php?pagina=ricerca-iscritti'
        @client.next_xpath        = next_xpath
        @client.page_loaded_xpath = page_loaded_xpath
        @client.add_ricerca r1
      end

      it 'esegue una ricerca singola su Fnovi' do
        @client.to_file_json

        seeker = BeautiForm.new force: 'dynamic'
        pagine = seeker.risultato[:pagine]
        mode   = seeker.risultato[:mode]
        pagine[[0, 0]].should_not be_nil
        pagine[[1, 0]].should be_nil
        mode.should be == :dynamic
      end

      it 'esegue una ricerca multipla su Fnovi' do
        r2 = {'//*[@id="searchField"]' => 'Verdi'}
        @client.add_ricerca r2
        @client.to_file_json

        seeker = BeautiForm.new force: 'dynamic'
        pagine = seeker.risultato[:pagine]
        mode   = seeker.risultato[:mode]
        pagine[[0, 0]].should_not be_nil
        pagine[[1, 0]].should_not be_nil
        pagine[[2, 0]].should be_nil
        mode.should be == :dynamic
      end

    end

    context 'given a PagineBianche search request' do
      before(:each) do
        next_xpath = '//*[@class="listing-pag-n listing-pag-succ"]' # xpath del tasto next
        page_loaded_xpath = '//*[@id="container"]/div[4]' # marker di fine pagina - garantisce che la pagina ha terminato il caricamento
        r1 = {:'//*[@id="input_cosa"]' => 'De Amicis', :'//*[@id="input_dove"]' => 'Roma'}

        @client                   = ClientSimulator.new 'http://www.paginebianche.it/'
        @client.next_xpath        = next_xpath
        @client.page_loaded_xpath = page_loaded_xpath
        @client.add_ricerca r1
      end

      it 'esegue una ricerca singola su PagineBianche' do
        @client.to_file_json

        seeker = BeautiForm.new force: 'dynamic'
        pagine = seeker.risultato[:pagine]
        mode   = seeker.risultato[:mode]
        pagine[[0, 0]].should_not be_nil
        pagine[[1, 0]].should be_nil
        mode.should be == :dynamic
      end

      it 'esegue una ricerca multipla su PagineBianche' do
        r2 = {:'//*[@id="input_cosa"]' => 'Bonucci', :'//*[@id="input_dove"]' => 'Roma'}
        @client.add_ricerca r2
        @client.to_file_json

        seeker = BeautiForm.new force: 'dynamic'
        pagine = seeker.risultato[:pagine]
        mode   = seeker.risultato[:mode]
        pagine[[0, 0]].should_not be_nil
        pagine[[1, 0]].should_not be_nil
        pagine[[2, 0]].should be_nil
        mode.should be == :dynamic
      end
    end
  end

  describe '#click' do

  end

  describe '#wait_for_page_load' do

  end

  describe '#set_next_button' do

  end

  describe '#displayed?' do

  end


end