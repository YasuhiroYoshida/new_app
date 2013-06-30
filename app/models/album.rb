class Album < ActiveRecord::Base
  attr_accessible :album_title, :photo, :photo_file_name
  has_attached_file :photo, 
    :styles => { 
      :medium      => "300x300>", 
      :thumb       => "100x100>" },
    #:path        => "/assets/album_covers/:id/:style/:basename.:extension",
    :url         => ":rails_root/public/assets/album_covers/:id/:style/:basename.:extension",
    :default_url => "/images/:style/missing.png"
  belongs_to :user
  default_scope -> { order('album_title ASC') }
  validates :user_id, presence: true
  validates :album_title, presence: true, length: { maximum: 200}
#  validates :avatar, :attachment_presence => true
#  validates_with AttachmentPresenceValidator, :attributes => :avatar
end
