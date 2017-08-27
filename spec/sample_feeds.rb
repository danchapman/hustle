require 'rss'

module SampleFeeds
  def mock_feed
    rss = File.read("#{File.dirname(__FILE__)}/sample_feeds/stack_overflow.xml")
    RSS::Parser.parse(rss)
  end
end