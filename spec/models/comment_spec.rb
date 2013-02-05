require 'spec_helper'

describe Comment do
  subject { build(:comment) }

  it { should belong_to :user }
  it { should belong_to :request }
  it { should validate_presence_of :content }
end
