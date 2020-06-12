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
      nama_dosen: dosen_list.css("h2")[0]&.text,
      nidn_dosen: dosen_list.css("h2")[1]&.text
    }
    if dosen[:nama_dosen] != nil
      dosens << dosen
    end
  end
  # byebug

  File.delete("daftar_dosen.html") if File.exist?("daftar_dosen.html")
  File.open("daftar_dosen.html", "w") do |f|
    f.puts '<!DOCTYPE html>'
    f.puts '<html lang="en">'
    f.puts '<head>'
    f.puts '<meta charset="UTF-8">'
    f.puts "<title>Daftar Dosen Universitas Mulia (#{dosens.count} dosen)</title>"
    f.puts '<style>table,th,td{border:1px solid black;border-collapse:collapse;}</style>'
    f.puts '</head>'
    f.puts '<body>'
    f.puts '<table>'
    dosens.each do |dosen|
      f.puts '<tr>'
      f.puts "<td>#{dosen[:nama_dosen]}</td>"
      f.puts "<td>#{dosen[:nidn_dosen]}</td>"
      f.puts '</tr>'
    end
    f.puts '</table>'
    f.puts '</body>'
    f.puts '</html>'
  end

  puts "TOTAL DOSEN: #{dosens.count} orang"
end

scraper
