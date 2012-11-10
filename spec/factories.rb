FactoryGirl.define do
  factory :user do
    sequence :username do |s|
      Faker::Name.first_name.downcase + s.to_s
    end
    email { Faker::Internet.email }
    role 'provider'
    name { Faker::Name.name }
    password 'testpassword'
  end

  factory :request do
    title 'Test Request'
    description 'This is a test request.'
    association :requester, factory: :user, role: 'requester'
    system
    severity 'moderate'
    status
  end

  factory :comment do
    content 'This is a comment.'
    user
    request
  end

  factory :system do
    name { Faker::Company.name }
  end

  factory :status do
    title 'new'
  end

  factory :responsibility do
    user
    system
  end

  factory :attachment do
    title 'Test Attachment'
    file File.new 'spec/fixtures/attachment.png'
    user
    request
  end
end
