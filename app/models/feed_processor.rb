class FeedProcessor

  def initialize(feed)
    @items = feed.items 
  end

  def process
    save_new_jobs
    # Get the list of new uniq tags
    # Check if any of the tags currently exist, and if not, create them
  end

  private

  def save_new_jobs
    new_jobs.map do |job|
      Job.new(
        guid: job.guid.content.to_i,
        title: job.title,
        description: job.description,
        pub_date: job.pubDate,
        link: job.link
      ).save
    end
  end

  def new_jobs
    @new_jobs ||= @items.reject {|i| existing_guids.include? i.guid.content.to_i}
  end

  def existing_guids
    @existing_guids = Job.where({ guid: new_guids })
  end

  def new_guids
    @new_guids ||= @items.map {|i| i.guid.content}
  end
end