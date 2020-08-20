require 'httparty'
require 'nokogiri'
require 'byebug'
require_relative './scraper'
require_relative './template'

def main
  begin
    target_url = "http://baak.universitasmulia.ac.id/dosen/"
    unparsed_page = HTTParty.get(target_url)
  rescue SocketError
    puts "ERROR: Target URL tidak dikenal (salah alamat)"
    exit
  end

  parsed_page = Nokogiri::HTML(unparsed_page)

  # daftar semua dosen
  dosens = Scraper.new(parsed_page).fetch_all

  # daftar dosen pria
  dosens_pria = Scraper.new(parsed_page).fetch_by_gender('pria')

  # daftar dosen wanita
  dosens_wanita = Scraper.new(parsed_page).fetch_by_gender('wanita')

  # byebug

  # template
  Template.new(dosens, dosens_pria, dosens_wanita).create_html

  puts "TOTAL SELURUH DOSEN : #{dosens.count} orang"
  puts "TOTAL DOSEN PRIA    : #{dosens_pria.count} orang"
  puts "TOTAL DOSEN WANITA  : #{dosens_wanita.count} orang"
end

main
