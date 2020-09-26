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
