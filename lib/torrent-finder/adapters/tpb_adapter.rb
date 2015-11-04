require 'nokogiri'
require 'open-uri'
require 'httparty'
require 'mechanize'

module TorrentFinder
  module Adapters
    class TpbAdapter < Adapter
      # name of the adapter
      def self.name
        "tpb"
      end

      # list recently available torrent
      def list(page=0)
        url = page == 0 ? "https://thepiratebay.mn/browse/208" : "https://thepiratebay.mn/browse/208/#{page.to_s}/3"
        response = HTTParty.get(url)
        parse_html(response.body)
      end

      # search and return available torrent
      def search(terms)
        agent = Mechanize.new
        agent.get 'https://thepiratebay.mn'
        search_form = agent.page.form('q')
        search_form.q = terms
        search_form.submit
        parse_html(agent.page)
      end

      protected
      def parse_html(doc)
        doc = Nokogiri::HTML(doc) if doc.is_a?(String)
        rows = doc.search("table#searchResult tr")
        rows.collect do |row|
          next if row.attr('class') == 'header'
          next if row.to_s.include?('https://piratebay.org/img/next.gif')
          name = row.search("a.detLink").first.text rescue nil
          url = row.search('img[alt="Magnet link"]').first.parent['href'] rescue nil
          Torrent.new(name, url)
        end.compact.select {|row| row.name && row.url }
      end
    end
  end
end