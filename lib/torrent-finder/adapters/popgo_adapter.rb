require 'nokogiri'
require 'open-uri'
require 'httparty'

module TorrentFinder
  module Adapters
    class PopgoAdapter < Adapter
      # name of the adapter
      def self.name
        "popgo"
      end

      # list recently available torrent
      def list(page=0)
        url = page == 0 ? "http://share.popgo.org/" : "http://share.popgo.org/search.php?title=&groups=&uploader=&sorts=&orderby=&page=#{(page+1).to_s}"
        response = HTTParty.get(url)
        parse_html(response.body)
      end

      # search and return available torrent
      def search(terms)
        response = HTTParty.get("http://share.popgo.org/search.php", :query => {"title" => terms})
        parse_html(response.body)
      end

      protected
      def parse_html(html)
        doc = Nokogiri::HTML(html)
        rows = doc.search("#index_maintable tr")
        rows.collect do |row| 
          seed = row.xpath('.//*[@class="inde_tab_seedname"]').first
          name = seed.text.strip rescue nil
          url = row.xpath('.//a[@title="下载种子"]').first["href"] rescue nil

          Torrent.new(name, url)
        end.select {|row| row.name && row.url }
      end
    end
  end
end