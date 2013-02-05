FactoryGirl.define do
  factory :user do
    sequence :username do |s|
      "username#{s}"
    end
    sequence :email do |s|
      "username#{s}@example.com"
    end
    role 'administrator'
    name { Faker::Name.name }

    factory :database_user, class: DatabaseUser do
      password 'testpassword'
    end

    factory :directory_user, class: DirectoryUser do
    end
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
    sequence :name do |s|
      "system#{s}"
    end
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
