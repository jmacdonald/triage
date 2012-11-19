require 'spec_helper'

describe User do
  subject { FactoryGirl.create :user }

  it { should have_many :requests }
  it { should have_many :assignments }
  it { should have_many :comments }
  it { should have_many :attachments }
  it { should have_many :responsibilities }
  it { should have_many(:systems).through(:responsibilities) }
  it { should validate_presence_of :email }
  it { should validate_presence_of :username }
  it { should validate_presence_of :role }
  it { should validate_presence_of :name }
  it { should allow_mass_assignment_of :email }
  it { should allow_mass_assignment_of :username }
  it { should allow_mass_assignment_of :password }
  it { should allow_mass_assignment_of :password_confirmation }
  it { should allow_mass_assignment_of :remember_me }
  it { should allow_mass_assignment_of :name }
  it { should allow_mass_assignment_of :available }
  it { should allow_mass_assignment_of :role }
  it { should validate_uniqueness_of :email }
  it { should validate_uniqueness_of :username }
  it { should ensure_inclusion_of(:role).in_array %w(administrator provider requester) }
  it { should allow_value('jordan').for(:username) }
  it { should_not allow_value('$#@!%$_').for(:username) }

  it 'should be able to display itself as a string' do
    subject.to_s.should eq(subject.name)
  end

  describe 'available attribute' do
    it 'should default to true' do
      subject.reload.available.should be_true
    end
  end

  describe 'available scope' do
    it 'should only return available users' do
      # Create some available and unavailable users.
      FactoryGirl.create_list :user, 5
      FactoryGirl.create_list :user, 7, available: false

      # Check each returned user to make sure they're available
      User.available.each do |user|
        user.available.should be_true
      end
    end
  end
end
