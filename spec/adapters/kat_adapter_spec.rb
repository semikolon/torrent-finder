require 'spec_helper'
require 'torrent-finder/adapters/kat_adapter'

describe TorrentFinder::Adapters::KatAdapter do
  context "#name" do
    it "should be kat" do
      expect(TorrentFinder::Adapters::KatAdapter.name).to eq("kat")
    end
  end

  context "#list", :vcr => {:record => :new_episodes} do
    it "should list first page of torrent" do
      list = subject.list
      expect(list).to be_a(Array)
      expect(list.any?{|item| item[:name] =~ /Quantico/}).to be_truthy
    end
  end

  context "#search", :vcr => {:record => :new_episodes} do
    it "should search torrent" do
      list = subject.search("Top Gear")
      expect(list).to be_a(Array)
      expect(list.any?{|item| item[:name] =~ /Top Gear/}).to be_truthy
    end
  end
end