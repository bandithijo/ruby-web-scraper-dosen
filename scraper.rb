require 'httparty'
require 'nokogiri'
require 'byebug'
require 'date'

def scraper
  target_url = "http://baak.universitasmulia.ac.id/dosen/"
  unparsed_page = HTTParty.get(target_url)
  parsed_page = Nokogiri::HTML(unparsed_page)

  # daftar semua dosen
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

  # daftar dosen pria
  dosens_pria = Array.new
  dosen_pria_listings = parsed_page.css('div.elementor-widget-wrap')[9].css('p')
  dosen_pria_listings.each do |dosen_pria_list|
    nama_nidn_dosen_pria = dosen_pria_list&.text&.gsub(/(^\w.*?:)|(NIDN :\s)/, "").strip
    dosen = {
      nama_dosen_pria: nama_nidn_dosen_pria&.gsub(/[^A-Za-z., ]/i, ''),
      nidn_dosen_pria: nama_nidn_dosen_pria&.gsub(/[^0-9]/i, '')
    }
    if dosen[:nama_dosen_pria] != nil
      dosens_pria << dosen
    end
  end

  # daftar dosen wanita
  dosens_wanita = Array.new
  dosen_wanita_listings = parsed_page.css('div.elementor-widget-wrap')[10].css('p')
  dosen_wanita_listings.each do |dosen_wanita_list|
    nama_nidn_dosen_wanita = dosen_wanita_list&.text&.gsub(/(^\w.*?:)|(NIDN :\s)/, "").strip
    dosen = {
      nama_dosen_wanita: nama_nidn_dosen_wanita&.gsub(/[^A-Za-z., ]/i, ''),
      nidn_dosen_wanita: nama_nidn_dosen_wanita&.gsub(/[^0-9]/i, '')
    }
    if dosen[:nama_dosen_wanita] != nil
      dosens_wanita << dosen
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
    f.puts '<h1>Daftar Dosen Universitas Mulia Balikpapan</h1>'
    f.puts "<p>Data terakhir diparsing: #{Date.today}</p>"

    f.puts '<h2>Daftar Semua Dosen</h2>'
    f.puts "<p>Jumlah Seluruh Dosen: #{dosens.size} orang</p>"
    f.puts '<table>'
    dosens.each.with_index(1) do |dosen, index|
      f.puts '<tr>'
      f.puts "<td>#{index}</td>"
      f.puts "<td>#{dosen[:nama_dosen]}</td>"
      f.puts "<td>#{dosen[:nidn_dosen]}</td>"
      f.puts '</tr>'
    end
    f.puts '</table>'

    f.puts '<h2>Daftar Dosen Pria</h2>'
    f.puts "<p>Jumlah Dosen Pria: #{dosens_pria.size} orang</p>"
    f.puts '<table>'
    dosens_pria.each.with_index(1) do |dosen, index|
      f.puts '<tr>'
      f.puts "<td>#{index}</td>"
      f.puts "<td>#{dosen[:nama_dosen_pria]}</td>"
      f.puts "<td>#{dosen[:nidn_dosen_pria]}</td>"
      f.puts '</tr>'
    end
    f.puts '</table>'

    f.puts '<h2>Daftar Dosen Wanita</h2>'
    f.puts "<p>Jumlah Dosen Wanita: #{dosens_wanita.size} orang</p>"
    f.puts '<table>'
    dosens_wanita.each.with_index(1) do |dosen, index|
      f.puts '<tr>'
      f.puts "<td>#{index}</td>"
      f.puts "<td>#{dosen[:nama_dosen_wanita]}</td>"
      f.puts "<td>#{dosen[:nidn_dosen_wanita]}</td>"
      f.puts '</tr>'
    end
    f.puts '</table>'

    f.puts '</body>'
    f.puts '</html>'
  end

  puts "TOTAL SELURUH DOSEN : #{dosens.count} orang"
  puts "TOTAL DOSEN PRIA    : #{dosens_pria.count} orang"
  puts "TOTAL DOSEN WANITA  : #{dosens_wanita.count} orang"
end

scraper
