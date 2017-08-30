require 'rss'

module SampleFeeds
  def mock_feed(file="stack_overflow") 
    rss = File.read("#{File.dirname(__FILE__)}/sample_feeds/#{file}.xml")
    RSS::Parser.parse(rss)
  end
end