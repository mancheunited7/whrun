class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :run
  has_many :notifications, dependent: :destroy
end
