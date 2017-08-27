class Job < ApplicationRecord
  has_many :job_tags, dependent: :destroy
  has_many :tags, through: :job_tags
end