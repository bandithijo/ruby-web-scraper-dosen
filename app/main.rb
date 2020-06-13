require 'httparty'
require 'nokogiri'
require 'byebug'
require 'active_record'
require_relative './models/dosen'

def db_configuration
  db_configuration_file = File.join(File.expand_path('..', __FILE__), '..', 'db', 'config.yml')
  YAML.load(File.read(db_configuration_file))
end

ActiveRecord::Base.establish_connection(db_configuration["development"])

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

  if dosens.size == Dosen.all.size
    puts "INFO: Data dosen sudah diparsing. Tidak ada data baru."
    puts "TOTAL DOSEN: #{dosens.size} orang"
  elsif Dosen.all.size == 0 || dosens.size > Dosen.all.size
    dosens.each do |dosen|
      Dosen.create(nama_dosen: dosen[:nama_dosen], nidn_dosen: dosen[:nidn_dosen])
      puts "Dosen: #{dosen[:nama_dosen]}, berhasil disimpan!"
    end
    puts "TOTAL DOSEN (LAMA): #{dosens.size} orang"
    puts "TOTAL DOSEN (BARU): #{Dosen.all.size} orang"
    puts "DOSEN BARU: #{dosens.size - Dosen.all.size} orang"
  end

end

scraper