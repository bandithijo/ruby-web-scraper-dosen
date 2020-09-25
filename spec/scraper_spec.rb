# frozen_string_literal: true

require_relative '../scraper.rb'
require_relative '../target.rb'

describe Scraper do
  parsed_page = Target.get_target_url('http://baak.universitasmulia.ac.id/dosen/')

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
end
