require 'spec_helper'

describe Album do

  let(:user) { FactoryGirl.create(:user) }
  before { @album = user.albums.build(user: user, album_title: "Thriller", photo: Rack::Test::UploadedFile.new(Rails.root + 'spec/fixtures/files/' + 'blue.jpeg', 'image/jpg')) }

  subject { @album }

  it { should respond_to(:user) }
  it { should respond_to(:user_id) }
  it { should respond_to(:album_title) }
  it { should respond_to(:photo_file_name) }
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
    before { @album.album_title = "a" * 41 }
    it { should_not be_valid }
  end

  describe "album associations" do
    let(:other_user) { FactoryGirl.create(:user) }
  
    let!(:my_album_a) do
      FactoryGirl.create(:album, 
        user_id: user.id, 
        album_title: "a", 
        photo: Rack::Test::UploadedFile.new(Rails.root + 'spec/fixtures/files/' + 'blue.jpeg', 'image/jpg')
      )
    end
    let!(:my_album_b) do
      FactoryGirl.create(:album,
        user: user,
        album_title: "b",
        photo: Rack::Test::UploadedFile.new(Rails.root + 'spec/fixtures/files/' + 'blue.jpeg', 'image/jpg')
      )
    end
    let!(:your_album_c) do
      FactoryGirl.create(:album,
        user: other_user,
        album_title: "c",
        photo: Rack::Test::UploadedFile.new(Rails.root + 'spec/fixtures/files/' + 'blue.jpeg', 'image/jpg')
      )
    end
    describe "status" do
      its(:list) { should include(my_album_a) }
      its(:list) { should include(my_album_b) }
      its(:list) { should_not include(your_album_c) }
    end
  end

end
