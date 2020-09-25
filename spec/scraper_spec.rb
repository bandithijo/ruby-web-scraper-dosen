# frozen_string_literal: true

require 'httparty'
require 'nokogiri'
require_relative '../scraper.rb'

def get_target_url(target_url)
  target_url = target_url
  unparsed_page = HTTParty.get(target_url)
  Nokogiri::HTML(unparsed_page.body)
rescue SocketError
  puts 'ERROR: Target URL tidak dikenal (salah alamat)'
  exit
end

describe Scraper do
  parsed_page = get_target_url('http://baak.universitasmulia.ac.id/dosen/')

  describe '.fetch_all' do
    context 'fetching all dosens data' do
      it 'returns array dosens' do
        expect(Scraper.new(parsed_page).fetch_all.class).to eq(Array)
      end

      it 'resturns first dosens name' do
        expect(Scraper.new(parsed_page).fetch_all[0][:nama_dosen]).to eq('Abdul Fatah')
      end

      it 'resturns last dosens name' do
        expect(Scraper.new(parsed_page).fetch_all[-1][:nama_dosen]).to eq('Zara Zerina Azizah, S.Pd.I, S.E., M.M')
      end
    end
  end
end
