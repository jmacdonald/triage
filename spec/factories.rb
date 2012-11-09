FactoryGirl.define do
  factory :user do
    username { Faker::Name.first_name.downcase }
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
end
