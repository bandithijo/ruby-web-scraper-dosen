# frozen_string_literal: true

require_relative '../scraper.rb'
require_relative '../target.rb'

target_url = 'http://baak.universitasmulia.ac.id/dosen/'
parsed_page = Target.get_target_url(target_url)

describe Scraper do
  describe '.fetch_all' do
    context 'fetching all dosens data' do
      it 'returns array of dosens' do
        expect(Scraper.new(parsed_page).fetch_all.class)
          .to eq(Array)
      end

      it 'returns first nama_dosen as alphabet' do
        expect(Scraper.new(parsed_page).fetch_all.first[:nama_dosen])
          .to match(/[a-zA-z\s\"]/)
      end

      it 'returns first nidn_dosen as numeric' do
        expect(Scraper.new(parsed_page).fetch_all.first[:nidn_dosen])
          .to match(/[0-9]/)
      end

      it 'returns last nama_dosen as alphabet' do
        expect(Scraper.new(parsed_page).fetch_all.last[:nama_dosen])
          .to match(/[a-zA-z\s\"]/)
      end

      it 'returns last nidn_dosen as numeric' do
        expect(Scraper.new(parsed_page).fetch_all.last[:nidn_dosen])
          .to match(/[0-9]/)
      end
    end
  end

  describe '.fetch_by_gender' do
    context 'fetching all dosens pria data by gender' do
      it 'returns array of dosens pria' do
        expect(Scraper.new(parsed_page).fetch_by_gender('pria').class)
          .to eq(Array)
      end

      it 'returns first nama_dosen pria as alphabet' do
        expect(Scraper.new(parsed_page).fetch_by_gender('pria').first[:nama_dosen])
          .to match(/[a-zA-z\s\"]/)
      end

      it 'returns first nidn_dosen pria as numeric' do
        expect(Scraper.new(parsed_page).fetch_by_gender('pria').first[:nidn_dosen])
          .to match(/[0-9]/)
      end

      it 'returns last nama_dosen pria as alphabet' do
        expect(Scraper.new(parsed_page).fetch_by_gender('pria').last[:nama_dosen])
          .to match(/[a-zA-z\s\"]/)
      end

      it 'returns last nidn_dosen pria as numeric' do
        expect(Scraper.new(parsed_page).fetch_by_gender('pria').last[:nidn_dosen])
          .to match(/[0-9]/)
      end
    end

    context 'fetching all dosens wanita data by gender' do
      it 'returns array of dosens wanita' do
        expect(Scraper.new(parsed_page).fetch_by_gender('wanita').class)
          .to eq(Array)
      end

      it 'returns first nama_dosen wanita as alphabet' do
        expect(Scraper.new(parsed_page).fetch_by_gender('wanita').first[:nama_dosen])
          .to match(/[a-zA-z\s\"]/)
      end

      it 'returns first nidn_dosen wanita as numeric' do
        expect(Scraper.new(parsed_page).fetch_by_gender('wanita').first[:nidn_dosen])
          .to match(/[0-9]/)
      end

      it 'returns last nama_dosen wanita as alphabet' do
        expect(Scraper.new(parsed_page).fetch_by_gender('wanita').last[:nama_dosen])
          .to match(/[a-zA-z\s\"]/)
      end

      it 'returns last nidn_dosen wanita as numeric' do
        expect(Scraper.new(parsed_page).fetch_by_gender('wanita').last[:nidn_dosen])
          .to match(/[0-9]/)
      end
    end
  end
end
