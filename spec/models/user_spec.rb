require 'spec_helper'

describe User do
  subject { FactoryGirl.build :user }

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
  it { should allow_mass_assignment_of :role }
  it { should validate_uniqueness_of :email }
  it { should validate_uniqueness_of :username }
  it { should ensure_inclusion_of(:role).in_array %w(administrator provider requester) }
  it { should allow_value('jordan').for(:username) }
  it { should_not allow_value('$#@!%$_').for(:username) }

  it 'should be able to display itself as a string' do
    subject.to_s.should eq(subject.name)
  end
end
