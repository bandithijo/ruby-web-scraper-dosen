require 'httparty'
require 'nokogiri'
require 'byebug'

def scraper
  target_url = "http://baak.universitasmulia.ac.id/dosen/"
  unparsed_page = HTTParty.get(target_url)
  parsed_page = Nokogiri::HTML(unparsed_page)
  dosens = Array.new
  dosen_listings = parsed_page.css('div.elementor-widget-wrap')
  dosen_listings.each do |dosen_list|
    dosen = {
      nama_dosen: dosen_list.css("h2")[0]&.text&.gsub("\n", " "),
      nidn_dosen: dosen_list.css("h2")[1]&.text
    }
    if dosen[:nama_dosen] != nil
      dosens << dosen
    end
  end
  # byebug

  File.delete("daftar_dosen.csv") if File.exist?("daftar_dosen.csv")
  File.open("daftar_dosen.csv", "w") do |f|
    f.puts 'no;nama_dosen;nidn_dosen'
    dosens.each.with_index(1) do |dosen, index|
      f.puts "#{index}\;#{dosen[:nama_dosen].strip}\;#{dosen[:nidn_dosen].strip}"
    end
    f.close
  end

  puts "TOTAL DOSEN: #{dosens.count} orang"
end

scraper
