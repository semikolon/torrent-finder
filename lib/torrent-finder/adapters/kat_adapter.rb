require 'nokogiri'
require 'open-uri'
require 'httparty'
require 'mechanize'

module TorrentFinder
  module Adapters
    class KatAdapter < Adapter
      # name of the adapter
      def self.name
        "kat"
      end

      # list recently available torrent
      def list(page=0)
        url = page == 0 ? "http://kattorrents.me/tv/" : "http://kattorrents.me/tv/#{page.to_s}"
        response = HTTParty.get(url)
        parse_html(response.body)
      end

      # search and return available torrent
      def search(terms)
        agent = Mechanize.new
        agent.get 'http://kattorrents.me/'
        search_form = agent.page.form_with(id:'searchform')
        search_form.q = terms
        search_form.submit
        parse_html(agent.page)
      end

      protected
      def parse_html(doc)
        doc = Nokogiri::HTML(doc) if doc.is_a?(String)
        rows = doc.search("table#mainSearchTable table.data tr")
        rows.collect do |row|
          next if row.attr('class') == 'firstr'
          name = row.search("a.cellMainLink").first.text rescue nil
          url = row.search('a[title="Torrent magnet link"]').first['href'] rescue nil
          Torrent.new(name, url)
        end.compact.select {|row| row.name && row.url }
      end
    end
  end
end