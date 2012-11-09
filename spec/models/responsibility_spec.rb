require 'spec_helper'

describe Responsibility do
  subject { FactoryGirl.build :responsibility }

  it { should belong_to :user }
  it { should belong_to :system }
  it { should validate_presence_of :user }
  it { should validate_presence_of :system }
end
