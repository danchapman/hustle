require 'rss'
require 'open-uri'

namespace :scrape do
  desc "Scrapes Stack Overflow for job openings"
  task stack_overflow: :environment do
    url = 'https://stackoverflow.com/jobs/feed?q=Software+Engineering+&r=True&ms=MidLevel&j=contract'
    open(url) do |rss|
      feed = RSS::Parser.parse(rss)
      FeedProcessor.new(feed).process
    end
  end
end
