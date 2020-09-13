# frozen_string_literal: true

class Scraper
  attr_reader :parsed_page, :gender
  attr_writer :dosens

  def initialize(parsed_page)
    @parsed_page = parsed_page
  end

  def fetch_all
    dosens = []
    dosen_listings = @parsed_page.css('div.elementor-widget-wrap p')
    dosen_listings[1..-10].each do |dosen_list|
      nama_nidn_dosen = dosen_list&.text&.gsub(/(^\w.*?:)|(NIDN :\s)/, '')&.strip
      dosen = {
        nama_dosen: nama_nidn_dosen&.gsub(/[^A-Za-z.,’ ]/i, ''),
        nidn_dosen: nama_nidn_dosen&.gsub(/[^0-9]/i, '')
      }

      dosens << dosen unless dosen[:nama_dosen].nil?
    end

    dosens
  end

  def fetch_by_gender(gender)
    case gender
    when 'pria' then index = 9
    when 'wanita' then index = 10
    else
      puts 'Gender Not Qualified!'
    end

    dosens = []
    dosen_listings = @parsed_page.css('div.elementor-widget-wrap')[index].css('p')
    dosen_listings.each do |dosen_list|
      nama_nidn_dosen = dosen_list&.text&.gsub(/(^\w.*?:)|(NIDN :\s)/, '')&.strip
      dosen = {
        nama_dosen: nama_nidn_dosen&.gsub(/[^A-Za-z., ]/i, ''),
        nidn_dosen: nama_nidn_dosen&.gsub(/[^0-9]/i, '')
      }

      dosens << dosen unless dosen[:nama_dosen].nil?
    end

    dosens
  end
end
