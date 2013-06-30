class AlbumsController < ApplicationController
  before_filter :signed_in_user #, only: [:create, :destroy]
  before_filter :correct_user,   only: :destroy

  def create
    @micropost = current_user.microposts.build(params[:micropost])
    @album = current_user.albums.build(params[:album])
    
    if @album.save
      flash[:success] = "Album registered!"
      redirect_to root_url
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def destroy
  end

  private
    
    def album_params
      params.require(:album).permit(:album_title)
    end

    def correct_user
      @album = current_user.albums.find_by(id: params[:id])
      redirect_to root_url if @album.nil?
    end
end