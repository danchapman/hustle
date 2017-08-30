require 'rails_helper'

RSpec.describe FeedProcessor, type: :model do
  describe "#process" do
    context "with only new jobs" do
      it "saves all jobs" do 
        subject = FeedProcessor.new(mock_feed)
        subject.process
        expect(Job.count).to eq(11)

        saved_job = Job.first
        expect(saved_job.guid).to eq(152285)
        expect(saved_job.title).to eq("Ruby Developer Ecommerce N. or S. America at Purepoint () (allows remote)")
        expect(saved_job.description).to eq("This is a fake description")
        expect(saved_job.pub_date.to_s).to eq("2017-08-22 16:10:13 UTC")
        expect(saved_job.link).to eq("https://stackoverflow.com/jobs/152285/ruby-developer-ecommerce-n-or-s-america-purepoint?a=P4rtZQSHAty")
      end

      context "with only new tags" do
        before(:each) do
          subject = FeedProcessor.new(mock_feed("stack_overflow_short"))
          subject.process
        end

        it "saves all tags" do
          expect(Tag.count).to eq(8)
          expect(Tag.first.name).to eq("ruby-on-rails")
        end

        it "associates all job tags" do
          saved_job_first = Job.first
          saved_job_last = Job.last
          expect(saved_job_first.tags.map(&:name)).to eq(['ruby-on-rails','ruby','postgresql'])
          expect(saved_job_last.tags.map(&:name)).to eq(["technical-interviewing", "data-structures", "algorithm", "java", "python"])
        end
      end

      context "with duplicate new tags" do
        before(:each) do
          subject = FeedProcessor.new(mock_feed)
          subject.process
        end

        it "saves only new uniq tags" do
          expect(Tag.count).to eq(37)
        end

        it "associates all job tags" do
          expect(JobTag.count).to eq(50)
        end
      end
    end

    context "with some new jobs" do
      it "saves new jobs only" do
        FeedProcessor.new(mock_feed("stack_overflow_short")).process
        expect(Job.count).to eq(2)

        FeedProcessor.new(mock_feed).process
        expect(Job.count).to eq(11)
      end

      it "saves new tags only" do
        FeedProcessor.new(mock_feed("stack_overflow_short")).process
        expect(Tag.count).to eq(8)

        FeedProcessor.new(mock_feed).process
        expect(Tag.count).to eq(37)
      end
    end

    context "with no new jobs" do
      it "saves no jobs" do
        FeedProcessor.new(mock_feed("stack_overflow_short")).process
        expect(Job.count).to eq(2)

        FeedProcessor.new(mock_feed("stack_overflow_short")).process
        expect(Job.count).to eq(2)
      end

      it "saves no tags" do
        FeedProcessor.new(mock_feed("stack_overflow_short")).process
        expect(Tag.count).to eq(8)

        FeedProcessor.new(mock_feed("stack_overflow_short")).process
        expect(Tag.count).to eq(8)
      end
    end 
  end
end
