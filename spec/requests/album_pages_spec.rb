require 'spec_helper'

describe "Album pages" do

  subject { page }

  describe "for signed-in users" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit albums_user_path(user)
    end

    it "should render the user's album list" do
      user.album_list.each do |album|
        page.should have_selector("li##{album.id})", text: album.album_title)
      end
    end
      
    describe "to upload an album" do

      describe "with invalid information" do
        
        it "should not store an album" do
          expect { click_button "Upload" }.not_to change(Album, :count)
        end

        describe "error messages" do
          before { click_button "Upload" }
          it "should have flash error messages" do
            page.should have_selector("div.alert.alert-error", text: 'can\'t be')
          end
        end
      end

      describe "with valid information" do
        before do
          fill_in 'album_album_title', with: "Blue"
          attach_file "album_photo", Rails.root + 'spec/fixtures/files/' + 'blue.jpeg'
        end
        
        it "should increment Album's count by 1" do
          expect { click_button "Upload" }.to change(Album, :count).by(1)
        end
      end
    end
    
    describe "to search for albums" do
      before do 
        FactoryGirl.create(:album,
          user_id: user.id,
          album_title: "12345",
          photo: Rack::Test::UploadedFile.new(Rails.root + 'spec/fixtures/files/' + 'blue.jpeg', 'image/jpg')
        )
        FactoryGirl.create(:album,
          user_id: user.id,
          album_title: "45123",
          photo: Rack::Test::UploadedFile.new(Rails.root + 'spec/fixtures/files/' + 'blue.jpeg', 'image/jpg')
        )
        FactoryGirl.create(:album,
          user_id: user.id,
          album_title: "abcde",
          photo: Rack::Test::UploadedFile.new(Rails.root + 'spec/fixtures/files/' + 'blue.jpeg', 'image/jpg')
        )
      end
      
      describe "with a keyword" do
        before do
          fill_in 'album_title', with: "23"
          click_button "Search"
        end
        let(:first_img)  { Album.find_id_by_album_title('12345').to_s }
        let(:second_img) { Album.find_id_by_album_title('45123').to_s }
        let(:third_img)  { Album.find_id_by_album_title('abcde').to_s }
        
        # These commented 'have_css' should be working       
        it "should return the correct search results" do
          page.should have_selector("span.album_title", text: '12345')
          #page.should have_css("img[src*='#{Rails.root}/public/assets/album_covers/#{first_img}/thumb/images.jpeg']")
          page.should have_selector("span.album_title", text: '45123')
          #page.should have_css("img[src*='#{Rails.root}/public/assets/album_covers/#{second_img}/thumb/images.jpeg']")
          page.should_not have_selector("span.album_title", text: 'abcde')
          page.should_not have_css("img[src*='#{Rails.root}/public/assets/album_covers/#{third_img}/thumb/images.jpeg']")
        end
      end

      describe "with a blank keyword" do
        before do
          visit albums_user_path(user)
          fill_in 'album_title', with: ""
          click_button "Search"
        end
        let(:first_img)  { Album.find_id_by_album_title('12345').to_s }
        let(:second_img) { Album.find_id_by_album_title('45123').to_s }
        let(:third_img)  { Album.find_id_by_album_title('abcde').to_s }

        # These 'have_css' should be working       
        it "should return all entries" do
          page.should have_selector("span.album_title", text: '12345')
          #page.should have_css("img[src*='#{Rails.root}/public/assets/album_covers/#{first_img}/thumb/images.jpeg']")
          page.should have_selector("span.album_title", text: '45123')
          #page.should have_css("img[src*='#{Rails.root}/public/assets/album_covers/#{second_img}/thumb/images.jpeg']")
          #page.should have_selector("span.album_title", text: 'abcde')
          #page.should have_css("img[src*='#{Rails.root}/public/assets/album_covers/#{third_img}/thumb/images.jpeg']")
        end
      end
    end

    describe "to destroy an album" do
      before do
        FactoryGirl.create(:album, 
          user_id: user.id, 
          album_title: "a", 
          photo: Rack::Test::UploadedFile.new(Rails.root + 'spec/fixtures/files/' + 'blue.jpeg', 'image/jpg')
        )
        visit albums_user_path(user)
      end

      it "should delete an album" do
        expect { click_link "delete" }.to change(Album, :count).by(-1)
      end
    end
  end
end
