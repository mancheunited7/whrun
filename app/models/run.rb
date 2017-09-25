class Run < ActiveRecord::Base
  belongs_to :user
  has_many :comments, dependent: :destroy

  validates:addresshyoji,presence: true
  validates:kyori,presence: true
  validates:taikai,presence:true
  validates:time,numericality:{greater_than: 0}
  #validates:hour,numericality: {
  #          only_integer: true ,greater_than_or_equal_to: 0}
  #validates:minute,numericality: {
  #          only_integer: true, greater_than_or_equal_to: 0,
  #          less_than_or_equal_to: 60}
  #validates:second,numericality: {
  #          only_integer: true, greater_than_or_equal_to: 0,
  #          less_than_or_equal_to: 60}
  validates:content,presence:true

  mount_uploader :avatar, AvatarUploader

  geocoded_by :address
  after_validation :geocode, if: Proc.new { |a| a.address_changed? }

  reverse_geocoded_by :latitude, :longitude
  after_validation :reverse_geocode,if: Proc.new { |a| a.latitude_changed? or a.longitude_changed? }
end
