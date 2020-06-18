require 'httparty'
require 'nokogiri'
require 'byebug'
require 'active_record'
require_relative './models/daftar_dosen'
require 'rake'

def db_configuration
  db_configuration_file = File.join(File.expand_path('..', __FILE__), '..', 'db', 'config.yml')
  YAML.load(File.read(db_configuration_file))
end

ActiveRecord::Base.establish_connection(db_configuration['development'])

def scraper
  target_url = "http://baak.universitasmulia.ac.id/dosen/"
  unparsed_page = HTTParty.get(target_url)
  parsed_page = Nokogiri::HTML(unparsed_page)
  dosens = Array.new
  dosen_listings = parsed_page.css('div.elementor-widget-wrap')
  dosen_listings.each do |dosen_list|
    dosen = {
      nama_dosen: dosen_list.css("h2")[0]&.text&.gsub("\n", " "),
      nidn_dosen: dosen_list.css("h2")[1]&.text&.gsub("\n", " ")
    }
    if dosen[:nama_dosen] != nil
      dosens << dosen
    end
  end
  # byebug

  if dosens.size == DaftarDosen.all.size
    puts "INFO: Data Dosen sudah diparsing. Tidak ada data baru."
    puts "TOTAL DOSEN: #{DaftarDosen.all.size} dosen"
  elsif DaftarDosen.all.size == 0 || dosens.size > DaftarDosen.all.size
    total_dosen_lama = DaftarDosen.all.size

    rake = Rake.application
    rake.init
    rake.load_rakefile
    rake['db:rollback'].invoke
    rake['db:migrate'].invoke

    dosens.each do |dosen|
      DaftarDosen.create(nama_dosen: dosen[:nama_dosen], nidn_dosen: dosen[:nidn_dosen])
      puts "Dosen: #{dosen[:nama_dosen]}, berhasil diinputkan!"
    end

    puts "TOTAL DOSEN (remote): #{dosens.size} dosen"
    puts "TOTAL DOSEN (local) : #{DaftarDosen.all.size} dosen"
    puts "TOTAL DOSEN BARU    : #{dosens.size - total_dosen_lama} dosen"
  end
end

scraper
