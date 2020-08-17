require 'httparty'
require 'nokogiri'
require 'byebug'
require 'date'

def scraper
  target_url = "http://baak.universitasmulia.ac.id/dosen/"
  unparsed_page = HTTParty.get(target_url)
  parsed_page = Nokogiri::HTML(unparsed_page)
  dosens = Array.new
  dosen_listings = parsed_page.css('div.elementor-widget-wrap p')
  dosen_listings[1..-2].each do |dosen_list|
    nama_nidn_dosen = dosen_list&.text&.gsub(/(^\w.*?:)|(NIDN :\s)/, "").strip
    dosen = {
      nama_dosen: nama_nidn_dosen&.gsub(/[^A-Za-z., ]/i, ''),
      nidn_dosen: nama_nidn_dosen&.gsub(/[^0-9]/i, '')
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
    f.puts '<style>table,th,td{border:1px solid black;border-collapse:collapse;}'
    f.puts 'td{padding:3px;}</style>'
    f.puts '</head>'
    f.puts '<body>'
    f.puts "<p>Data terakhir diparsing: #{Date.today}</p>"
    f.puts '<table>'
    dosens.each.with_index(1) do |dosen, index|
      f.puts '<tr>'
      f.puts "<td>#{index}</td>"
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
