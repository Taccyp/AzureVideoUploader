class Video < ActiveRecord::Base

  has_many :video_tags
  has_many :tags, through: :video_tags
end
