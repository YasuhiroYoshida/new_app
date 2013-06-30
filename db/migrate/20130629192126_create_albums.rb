class CreateAlbums < ActiveRecord::Migration
  def change
    create_table :albums do |t|
      t.string :album_title
      t.integer :user_id

      t.timestamps
    end
    add_index :albums, [:user_id, :album_title]
  end
end
