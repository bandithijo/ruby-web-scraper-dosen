# frozen_string_literal: true

require 'httparty'
require 'nokogiri'

class Target
  def self.get_target_url(target_url)
    target_url = target_url
    response = HTTParty.get(target_url)
    unparsed_page = response.body
    Nokogiri::HTML(unparsed_page)
  rescue SocketError
    puts 'ERROR: Target URL tidak dikenal (salah alamat)'
    exit
  rescue Errno::ENETUNREACH
    puts 'ERROR: Server tidak memberikan respon apapun'
    exit
  end
end
