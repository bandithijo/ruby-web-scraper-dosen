require 'httparty'
require 'nokogiri'
require 'byebug'
require 'pg'

def scraper
  target_url = "http://baak.universitasmulia.ac.id/dosen/"
  unparsed_page = HTTParty.get(target_url)
  parsed_page = Nokogiri::HTML(unparsed_page)
  dosens = Array.new
  dosen_listings = parsed_page.css('div.elementor-widget-wrap')
  dosen_listings.each do |dosen_list|
    dosen = {
      nama_dosen: dosen_list.css("h2")[0]&.text&.gsub("\n", "")&.gsub(/'/, "`")&.squeeze,
      nidn_dosen: dosen_list.css("h2")[1]&.text&.gsub("\n", "")
    }
    if dosen[:nama_dosen] != nil
      dosens << dosen
    end
  end
  # byebug

  begin
    conn = PG::Connection.open(dbname: 'web_scraper')
    conn.exec("DROP TABLE IF EXISTS daftar_dosens")
    conn.exec("CREATE TABLE daftar_dosens(
              id BIGSERIAL NOT NULL PRIMARY KEY,
              nama_dosen VARCHAR(100) NOT NULL,
              nidn_dosen VARCHAR(10))")

    dosens.each.with_index(1) do |dosen, index|
      conn.exec("INSERT INTO daftar_dosens VALUES(
               #{index},
               '#{dosen[:nama_dosen]}',
               '#{dosen[:nidn_dosen]}')")
      puts "Dosen: #{index} - #{dosen[:nama_dosen]}, berhasil diinput!"
    end
  rescue PG::Error => e
    puts e.message
  ensure
    conn.close if conn
  end

  puts "TOTAL DOSEN: #{dosens.count} orang"
end

scraper
