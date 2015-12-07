require 'claide'
require 'torrent-finder/adapters/popgo_adapter'
require 'torrent-finder/adapters/dmhy_adapter'
require 'torrent-finder/adapters/eztv_adapter'
require 'torrent-finder/adapters/nyaa_adapter'

module TorrentFinder
  class Command < CLAide::Command
    self.description = 'Find recent torrent or search specific torrent.'
    self.command = 'torrent-find'
    self.arguments = [CLAide::Argument.new("search", nil),]

    def self.options
      [
        ['--peerflix', 'launch peerflix with first matched result'],
        ['--site=site', 'use site, default popgo'],
        ['--list', 'list all available site']
      ].concat(super)
    end

    def initialize(argv)
      @use_peerflix = argv.flag?('peerflix', false)
      @list = argv.flag?('list', false)
      @site = argv.option('site', "tpb")
      @keywords = argv.shift_argument

      super
    end

    def run
      if @list
        puts "Available Sites: " + TorrentFinder::Adapters::Registry.adapters.collect {|a| a.name }.join(", ")
        return
      end

      begin
        require "torrent-finder/adapters/#{@site}_adapter"
      rescue
        # ignore any error here
      end

      adapter_clazz = TorrentFinder::Adapters::Registry.adapters.find{|adapter| adapter.name == @site }
      unless adapter_clazz
        puts "Not supported: #{@site}"  
        return     
      end

      adapter = adapter_clazz.new
      if @keywords
        torrents = adapter.search(@keywords)
      else
        torrents = adapter.list
      end

      if @use_peerflix
        torrent = torrents.find {|torrent| torrent.name.include?(@keywords) } || torrents.first
        if torrent.nil?
          puts "No torrent matches '#{@keywords}'"
        else
          exec %{peerflix "#{torrent.url}" --vlc -r}
        end
      else
        torrents.each do |torrent|
          puts "#{torrent.name},#{torrent.url}"
        end
      end
    end
  end
end
