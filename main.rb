#!/usr/bin/env ruby

require 'byebug'
require_relative 'scraper'
require_relative 'target'
require_relative 'template'

class Main
  def self.scraper
    parsed_page = Target.get_target_url('http://baak.universitasmulia.ac.id/dosen/')

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
end

Main.scraper

# Create index.html from daftar_dosen.html for rendering on netlify & vercel
%x(`cp -f daftar_dosen.html index.html`)
