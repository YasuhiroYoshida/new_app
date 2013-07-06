FactoryGirl.define do
  factory :user do
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}   
    password "foobar"
    password_confirmation "foobar"

    factory :admin do
      admin true
    end
  end

  factory :micropost do
    content "Lorem ipsum"
    user
  end

  factory :album do
    album_title "Thriller"
    photo Rack::Test::UploadedFile.new(Rails.root + 'spec/fixtures/files/' + 'blue.jpeg', 'image/jpg')
    user
  end
end

=begin
FactoryGirl.define do
  factory :user do
    name "Yasuhiro Yoshida"
    email "yasuhiro.yoppu@gmail.com"
    password "nyancat"
    password_confirmation "nyancat"
  end
end
=end