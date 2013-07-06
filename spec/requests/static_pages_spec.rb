require 'spec_helper'

#include ApplicationHelper

describe "Static pages" do

  subject { page }

  shared_examples_for "all static pages" do
    it { should have_selector('h1',    text: heading) }
    it { should have_selector('title', text: full_title(page_title)) }
  end

  describe "Home page" do
    before { visit root_path }
    let(:heading)    { 'New App' }
    let(:page_title) { '' }

    it_should_behave_like "all static pages"
    it { should_not have_selector 'title', text: '| Home' }

    describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
        FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet")
        sign_in user
        visit root_path
      end

      it "should render the user's feed" do
        user.feed.each do |item|
          page.should have_selector("li##{item.id}", text: item.content)
        end
      end
    
      describe "follower/following counts on home" do
        let(:other_user) { FactoryGirl.create(:user) }
        before do
          other_user.follow!(user)
          visit root_path
        end

        it { should_not have_link("0 following", href: following_user_path(user)) }
        it { should_not have_link("1 followers", href: followers_user_path(user)) }
      end

      # Excercise 11.5.4
      describe "follower/following stats on user profile" do
        let(:other_user) { FactoryGirl.create(:user) }
        before do
          other_user.follow!(user)
          visit user_path(user)
        end

        it { should have_link("0 following", href: following_user_path(user)) }
        it { should have_link("1 followers", href: followers_user_path(user)) }
      end

      describe "albums counts on home" do
        before do
          FactoryGirl.create(:album, user: user, album_title: "Blue", photo: Rack::Test::UploadedFile.new(Rails.root + 'spec/fixtures/files/' + 'blue.jpeg', 'image/jpg'))
          visit root_path(user)
        end
        it { should_not have_link("1 albums", href: albums_user_path(user)) }
      end

      describe "albums counts on user profile" do
        before do
          FactoryGirl.create(:album, user: user, album_title: "Blue", photo: Rack::Test::UploadedFile.new(Rails.root + 'spec/fixtures/files/' + 'blue.jpeg', 'image/jpg'))
          visit user_path(user)
        end
        it { should have_link("1 albums", href: albums_user_path(user)) }
      end
    end
  
    describe "side bar micropost counts" do
      let(:user) { FactoryGirl.create(:user) }

      describe "1 post" do
        before do
          FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
          sign_in user
          visit root_path
        end
      
        it { should have_content('1 micropost') } 
      end
  
      describe "2 posts" do
        before do
          FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
          FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet")
          sign_in user
          visit root_path
        end

        it { should have_content('2 microposts') }
      end
    end 
  end

  describe "micropost pagination" do
    let(:user) { FactoryGirl.create(:user) } 
    before do 
      99.times { FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum") }
      sign_in user
      visit root_path
    end

    it { should have_selector('div.pagination') }
    
    it "should list each micropost" do
      user.feed.paginate(page: 1).each do |item|
        page.should have_selector("li##{item.id}", text: item.content)
      end
    end
  end

  describe "Help page" do
    before { visit help_path }
    let(:heading)    { 'Help' }
    let(:page_title) { 'Help' }

    it_should_behave_like "all static pages"
  end

  describe "About page" do
    before { visit about_path }
    let(:heading)    { 'About Us' }
    let(:page_title) { 'About Us' }

    it_should_behave_like "all static pages"
  end

  describe "Contact page" do
    before { visit contact_path }
    let(:heading)    { 'Contact' }
    let(:page_title) { 'Contact' }

    it_should_behave_like "all static pages"
  end

  it "should have the right links on the layout" do
    visit root_path
    subject { page }
    click_link "About"
    page.should have_selector 'title', text: full_title('About Us')
    click_link "Help"
    page.should have_selector 'title', text: full_title('Help')
    click_link "Contact"
    page.should have_selector 'title', text: full_title('Contact')
#    click_link "Home"
#    click_link "Sign up now!"
#    page.should # fill in
#    click_link "New App"
#    page.should # fill in
  end
end