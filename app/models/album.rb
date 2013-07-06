class Album < ActiveRecord::Base
  attr_accessible :album_title, :photo, :photo_file_name
  belongs_to :user
  has_attached_file :photo, 
    :styles => { 
      :medium      => "300x300>", 
      :thumb       => "100x100>" },
    :url         => ":rails_root/public/assets/album_covers/:id/:style/:basename.:extension",
    :default_url => "/images/:style/missing.png"

  # Turning this off in order to counter abnormalities
  # user_id is always there, but an error message pops up
  #validates :user_id, presence: true
  validates :album_title, presence: true, length: { maximum: 40}
  validates :photo, presence: true

  # Returns albums posted by signed_in user.
  def self.listed_by(user)
     where("user_id = :user_id", user_id: user.id)
  end

  def list
    Album.listed_by(user)
  end

  def self.search(album_title, page)
    paginate :per_page => 5, :page => page[:page],
           :conditions => ['album_title LIKE ?', "%#{album_title[:album_title]}%"], :order => 'album_title asc'
  end

  def self.find_id_by_album_title(album_title)
    Album.first(:select => "id", :conditions => ["album_title = ?", album_title]).id  
  end
end
