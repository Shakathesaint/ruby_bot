require 'spec_helper'
require_relative '../app/controllers/driver_generator'

describe DriverGenerator do

  describe '#inizialize' do

    after(:each) do
      @driver.quit
    end
    context 'given valid data' do

      it 'crea un driver' do
        @driver = DriverGenerator.new
        puts defined?(@driver).nil?
        defined?(@driver).should_not be_nil
      end
    end
  end

  describe '#to_file_jason' do
    before(:all) do
      File.delete('*.json') #if File.exist?('strutturaDati.json')
      @driver = DriverGenerator.new
    end
    after(:each) do
      @driver.quit
    end
    context 'given a parameter' do
      it 'crea un file col nome passato' do
        File.exist?('strutturaDati.json').should be true
      end
    end

    context 'not given a parameter' do

    end

  end

  describe '#driver' do

  end


end