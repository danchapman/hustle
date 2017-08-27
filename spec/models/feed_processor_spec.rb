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
        it "saves all tags"
        it "associates all job tags"
      end

      context "with duplicate new tags" do
        it "saves new uniq tags"
        it "associates all job tags"
      end

      context "with some new tags" do
        it "saves new tags"
        it "associates all job tags"
      end

      context "with no new tags" do
        it "saves no new tags"
        it "associates all job tags"
      end
    end

    context "with some new jobs" do
      it "saves new jobs only"
    end

    context "with no new jobs" do
      it "saves no jobs"
    end 
  end
end
