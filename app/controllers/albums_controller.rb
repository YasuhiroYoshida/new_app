class AlbumsController < ApplicationController
  before_filter :signed_in_user #, only: [:create, :destroy]
  before_filter :correct_user,   only: :destroy

  respond_to :html, :js
  
  def index
    redirect_to albums_user_path(current_user)
  end


  def create
    @micropost = current_user.microposts.build(params[:micropost])
    @album = current_user.albums.build(params[:album])
    @albums = current_user.albums.paginate(page: params[:page], :order => 'album_title asc')
   
    if @album.save
      flash[:success] = 'Album uploaded!'
    else 
      flash.now[:error] = @album.errors.full_messages.to_sentence
    end
  
    render 'users/show_albums'
  end

  def destroy
    @album.destroy
    redirect_to albums_user_path(current_user)
  end
=begin
  def albums
    @albums = Album.search(params[:album_title], params[:page])
    redirect_to albums_user_path(current_user)
  end
=end
  private
    
    def album_params
      params.require(:album).permit(:album_title)
    end

    def correct_user
      @album = current_user.albums.find_by(id: params[:id])
      redirect_to root_url if @album.nil?
    end
end