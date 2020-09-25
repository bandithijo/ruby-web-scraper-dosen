# frozen_string_literal: true

require_relative '../scraper.rb'
require_relative '../target.rb'

target_url = 'http://baak.universitasmulia.ac.id/dosen/'
parsed_page = Target.get_target_url(target_url)

describe Target do
  describe 'get_target_url' do
    context 'get the response from target url' do
      it 'resturns Nokogiri::HTML::Document' do
        expect(parsed_page.class).to eq(Nokogiri::HTML::Document)
      end
    end
  end
end

describe Scraper do
  describe '.fetch_all' do
    context 'fetching all dosens data' do
      it 'returns array of dosens' do
        expect(Scraper.new(parsed_page).fetch_all.class).to eq(Array)
      end

      it 'returns first dosen name' do
        expect(Scraper.new(parsed_page).fetch_all.first[:nama_dosen]).to eq('Abdul Fatah')
      end

      it 'returns last dosen name' do
        expect(Scraper.new(parsed_page).fetch_all.last[:nama_dosen]).to eq('Zara Zerina Azizah, S.Pd.I, S.E., M.M')
      end
    end
  end

  describe '.fetch_by_gender' do
    context 'fetching all dosens data by gender' do
      it 'returns array of dosens pria' do
        expect(Scraper.new(parsed_page).fetch_by_gender('pria').class).to eq(Array)
      end

      it 'returns first dosen pria name' do
        expect(Scraper.new(parsed_page).fetch_by_gender('pria').first[:nama_dosen])
          .to eq('Abdul Fatah')
      end

      it 'returns last dosen pria name' do
        expect(Scraper.new(parsed_page).fetch_by_gender('pria').last[:nama_dosen])
          .to eq('Zainal Arifin')
      end

      it 'returns array of dosens wanita' do
        expect(Scraper.new(parsed_page).fetch_by_gender('wanita').class).to eq(Array)
      end

      it 'returns first dosen wanita name' do
        expect(Scraper.new(parsed_page).fetch_by_gender('wanita').first[:nama_dosen])
          .to eq('Alisa Alaina, S.E., M.M')
      end

      it 'returns last dosen wanita name' do
        expect(Scraper.new(parsed_page).fetch_by_gender('wanita').last[:nama_dosen])
          .to eq('Zara Zerina Azizah, S.Pd.I, S.E., M.M')
      end
    end
  end
end
