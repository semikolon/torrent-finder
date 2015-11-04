require 'spec_helper'
require 'torrent-finder/adapters/tpb_adapter'

describe TorrentFinder::Adapters::TpbAdapter do
  context "#name" do
    it "should be tpb" do 
      expect(TorrentFinder::Adapters::TpbAdapter.name).to eq("tpb")
    end
  end

  context "#list", :vcr => {:record => :new_episodes} do
    it "should list first page of torrent" do
      list = subject.list
      expect(list).to be_a(Array)
      expect(list.any?{|item| item[:name] =~ /Colbert/}).to be_truthy
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