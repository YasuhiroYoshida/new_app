require 'spec_helper'

describe "Album pages" do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "album registration" do
    before { visit root_path }

    describe "with invalid information" do
      
      it "should not register an album" do
        expect { click_button "Register" }.not_to change(Album, :count)
      end

      describe "error messages" do
        before { click_button "Register" }
        it { should have_content('error') }
      end
    end

    describe "valid information" do
      before { fill_in 'album_album_title', with: 'Lorem ipsum' }
      it "should register an album" do
        expect { click_button "Register" }.to change(Album, :count).by(1)
      end
    end
  end
end
