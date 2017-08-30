class FeedProcessor

  def initialize(feed)
    @items = feed.items 
  end

  def process
    @saved_jobs = save_new_jobs
    @saved_tags = save_new_tags + existing_tags
    associate_tags
  end

  private

  def save_new_jobs
    new_job_data.map do |job|
      new_job = Job.new(
        guid: job.guid.content.to_i,
        title: job.title,
        description: job.description,
        pub_date: job.pubDate,
        link: job.link
      )
      new_job.save
      new_job
    end
  end

  def save_new_tags
    new_tag_names.map do |tag_name|
      new_tag = Tag.new(name: tag_name)
      new_tag.save
      new_tag
    end
  end

  def associate_tags
    new_job_data.map {|job| associate_tag_for(job)}
  end

  def associate_tag_for(job)
    job.categories.each do |tag|
      JobTag.new(
        job_id: job_id_by(job.guid.content.to_i),
        tag_id: tag_id_by(tag.content)
      ).save
    end
  end

  def job_id_by(guid)
    @saved_jobs.select{|job| job.guid == guid}.first.id
  end

  def tag_id_by(name)
    @saved_tags.select{|tag| tag.name == name}.first.id
  end

  def new_tag_names
    @new_tags ||= new_job_tag_names.reject {|tag| existing_tags.map(&:name).include? tag}
  end

  def new_job_data
    @new_job_data ||= @items.reject {|i| existing_guids.include? i.guid.content.to_i}
  end

  def new_guids
    @new_guids ||= @items.map {|i| i.guid.content}
  end

  def new_job_tag_names
    @new_job_tag_names ||= new_job_data.map {|job| job.categories.map(&:content) }.flatten.uniq
  end

  def existing_guids
    @existing_guids = Job.where({ guid: new_guids }).map{|job| job.guid}
  end

  def existing_tags
    @existing_tags = Tag.where({ name: new_job_tag_names })
  end
end