require 'claide'

module TorrentFinder
  class Command < CLAide::Command
    self.description = 'Find recent torrent or search specific torrent.'
    self.command = 'torrent-find'

    def self.options
      [
        ['--peerflix', 'launch peerflix with first matched result'],
        ['--site=site', 'use site, default popgo'],
        ['--search=keywords', 'search keywords instead of find recent torrent']
      ].concat(super)
    end

    def initialize(argv)
      @use_peerflix = argv.flag?('peerflix', false)
      @site = argv.option('site', "popgo")
      @keywords = argv.option('search')
      super
    end

    def run
      require "torrent-finder/adapters/#{@site}_adapter"
      adapter_clazz = TorrentFinder::Adapters::Registry.adapters.first
      adapter = adapter_clazz.new

      if @keywords
        torrents = adapter.search(@keywords)
      else
        torrents = adapter.list
      end
      if @use_peerflix
        torrent = torrents.find {|torrent| torrent.name.include?(@keywords) } || torrents.first
        exec %{peerflix #{torrent.url} --vlc}
      else
        torrents.each do |torrent|
          puts "#{torrent.name},#{torrent.url}"
        end
      end
    end
  end
end