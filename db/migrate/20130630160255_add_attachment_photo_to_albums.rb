class AddAttachmentPhotoToAlbums < ActiveRecord::Migration
  def self.up
    change_table :albums do |t|
      t.attachment :photo
    end
  end

  def self.down
    drop_attached_file :albums, :photo
  end
end
