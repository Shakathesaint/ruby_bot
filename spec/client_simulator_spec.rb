require 'spec_helper'
require_relative '../app/controllers/client_simulator'
require_relative '../app/controllers/beauti_form'

describe ClientSimulator do

  describe '#inizialize' do
    # after(:each) do
    #   # @client.driver.quit
    # end

    context 'given valid data' do
      it 'crea un driver' do
        @client = ClientSimulator.new 'about:blank'
        # puts defined?(@client).nil?
        defined?(@client).should_not be_nil
      end
    end
  end

  describe '#to_file_jason' do
    before(:all) do
      # cancella tutti i file .json preesistenti
      Dir.glob('./app/controllers/*.json') { |filename| File.delete(filename) }
      Dir.glob("#{$dir}struttura_dati.json") { |filename| File.delete(filename) }
      @client = ClientSimulator.new 'about:blank'
    end
    # after(:all) do
    #   @client.driver.quit
    # end

    context 'given a parameter' do
      it 'crea un file col nome passato' do
        @client.to_file_json(name = './app/controllers/prova.json')
        File.exist?(name).should be true
      end
    end

    context 'not given a parameter' do
      it 'crea un file col nome strutturaDati.json' do
        @client.to_file_json
        default_dir = $dir
        File.exist?("#{default_dir}struttura_dati.json").should be true
      end
    end
  end

=begin
  describe '#driver' do
    after(:each) do
      @client.driver.quit
    end

    context 'given a ClientSimulator object' do
      it 'restituisce una variabile di tipo WebDriver' do
        @client = ClientSimulator.new
        @client.driver.class.to_s.should be == 'Selenium::WebDriver::Driver'
      end
    end
  end
=end



end