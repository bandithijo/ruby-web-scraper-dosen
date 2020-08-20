class Scraper

  attr_reader :parsed_page, :gender
  attr_writer :dosens

  def initialize(parsed_page)
    @parsed_page = parsed_page
  end

  def fetch_all
    dosens = Array.new
    dosen_listings = @parsed_page.css('div.elementor-widget-wrap p')
    dosen_listings[1..-2].each do |dosen_list|
      nama_nidn_dosen = dosen_list&.text&.gsub(/(^\w.*?:)|(NIDN :\s)/, "").strip
      dosen = {
        nama_dosen: nama_nidn_dosen&.gsub(/[^A-Za-z.,’ ]/i, ''),
        nidn_dosen: nama_nidn_dosen&.gsub(/[^0-9]/i, '')
      }

      if dosen[:nama_dosen] != nil
        dosens << dosen
      end
    end

    return dosens
  end

  def fetch_by_gender(gender)
    if gender == 'pria'
      index = 9
    elsif gender == 'wanita'
      index = 10
    else
      puts 'Gender Not Qualified!'
    end

    dosens = Array.new
    dosen_listings = @parsed_page.css('div.elementor-widget-wrap')[index].css('p')
    dosen_listings.each do |dosen_list|
      nama_nidn_dosen = dosen_list&.text&.gsub(/(^\w.*?:)|(NIDN :\s)/, "").strip
      dosen = {
        nama_dosen: nama_nidn_dosen&.gsub(/[^A-Za-z., ]/i, ''),
        nidn_dosen: nama_nidn_dosen&.gsub(/[^0-9]/i, '')
      }

      if dosen[:nama_dosen]
        dosens << dosen
      end
    end

    return dosens
  end
end
