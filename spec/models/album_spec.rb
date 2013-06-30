require 'spec_helper'

describe Album do

  let(:user) { FactoryGirl.create(:user) }
  before do
#    @album = Album.new(title: "Thriler", user_id: user.id) 
    @album = user.albums.build(album_title: "Thriller") 
  end

  subject { @album }

  it { should respond_to(:album_title) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  its(:user) { should eq user } 

  it { should be_valid }

  describe "when user_id is not present" do
    before { @album.user_id = nil }
    it { should_not be_valid }
  end

  describe "with blank album title" do
    before { @album.album_title = " " }
    it { should_not be_valid }
  end

  describe "with album_title that is too long" do
    before { @album.album_title = "a" * 201 }
    it { should_not be_valid }
  end
end
