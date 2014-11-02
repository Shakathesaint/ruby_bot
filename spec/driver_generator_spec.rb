require 'spec_helper'
require_relative '../app/controllers/driver_generator'

describe DriverGenerator do

  describe '#inizialize' do
    after(:each) do
      @driverGenerator.quit
    end

    context 'given valid data' do
      it 'crea un driver' do
        @driverGenerator = DriverGenerator.new
        puts defined?(@driverGenerator).nil?
        defined?(@driverGenerator).should_not be_nil
      end
    end
  end

  describe '#to_file_jason' do
    before(:all) do
      Dir.glob('./app/controllers/*.json') { |filename| File.delete(filename) }
      @driverGenerator = DriverGenerator.new
    end
    after(:all) do
      @driverGenerator.quit
    end

    context 'given a parameter' do
      it 'crea un file col nome passato' do
        @driverGenerator.to_file_json(name = './app/controllers/prova.json')
        File.exist?(name).should be true
      end
    end

    context 'not given a parameter' do
      it 'crea un file col nome strutturaDati.json' do
        @driverGenerator.to_file_json
        File.exist?('./app/controllers/strutturaDati.json').should be true
      end
    end
  end

  describe '#driver' do
    after(:each) do
      @driverGenerator.quit
    end

    context 'given a DriverGenerator object' do
      it 'restituisce una variabile di tipo WebDriver' do
        @driverGenerator = DriverGenerator.new
        @driverGenerator.driver.class.to_s.should be == 'Selenium::WebDriver::Driver'
      end
    end
  end

=begin
  describe '#quit' do
    before(:all) do
      @driverGenerator = DriverGenerator.new
    end
    # after(:each) do
    #   @driverGenerator.quit
    # end

    context 'given a DriverGenerator object' do
      it 'chiude il broswer aperto in precedenza' do
        @driverGenerator.quit
        expect(@driverGenerator.driver.navigate.to('www.google.it')).to receive(include('Errno::ECONNREFUSED: Connection refused'))
      end
    end
  end
=end

end