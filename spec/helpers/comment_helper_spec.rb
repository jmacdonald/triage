require 'spec_helper'

describe CommentHelper do
  describe 'content helpers' do
    before(:each) do
      @foreign_request = FactoryGirl.create :request

      @user1 = FactoryGirl.create :user
      @user2 = FactoryGirl.create :user

      @comment = FactoryGirl.create :comment
      @comment.content = content
    end

    describe 'escape' do
      let (:content) { '<html>' }

      it 'should escape html in the comment content' do
        escape(@comment.content).should eq('&lt;html&gt;')
      end

      it 'should return an html_safe string to prevent escaping' do
        escape(@comment.content).html_safe?.should be_true
      end
    end

    describe 'embolden_mentions' do
      context 'with a valid mention' do
        let(:content) { "@#{@user1.username} can you talk to @#{@user2.username}?" }

        it 'should wrap mentions in strong tags' do
          embolden_mentions(@comment.content).should eq("<strong>@#{@user1.username}</strong> can you talk to <strong>@#{@user2.username}</strong>?")
        end
      end

      context 'with an invalid mention' do
        let(:content) { "@invalid can you talk to @invalid2?" }

        it 'should not wrap mentions in strong tags' do
          embolden_mentions(@comment.content).should eq("@invalid can you talk to @invalid2?")
        end
      end

      context 'without any mentions' do
        let(:content) { "I'm working on this right now." }

        it 'should not change the content' do
          embolden_mentions(@comment.content).should eq("I'm working on this right now.")
        end
      end
    end

    describe 'link_references' do
      context 'with a valid reference' do
        let(:content) { "This issue is related to ##{@foreign_request.id}." }

        it 'should insert full URL links' do
          link_references(@comment.content).should eq("This issue is related to <a href=\"#{request_url(@foreign_request)}\">##{@foreign_request.id}</a>.")
        end
      end

      context 'with an invalid reference' do
        let(:content) { "This issue is related to #asdf." }

        it 'should not insert links' do
          link_references(@comment.content).should eq(@comment.content)
        end
      end

      context 'without any references' do
        let(:content) { "This issue is related to another." }

        it 'should not change the content' do
          link_references(@comment.content).should eq(@comment.content)
        end
      end
    end

    describe 'enrich' do
      let(:content) { "@#{@user1.username}, is this related to ##{@foreign_request.id}?" }

      it 'should run all comment helpers' do
        enrich(@comment.content).should eq(link_references embolden_mentions escape @comment.content)
      end
    end
  end

  describe 'request_role' do
    before(:each) do
      @requester = FactoryGirl.create :user, role: 'requester'
      @provider = FactoryGirl.create :user, role: 'provider'
      @administrator = FactoryGirl.create :user, role: 'administrator'

      @request = FactoryGirl.create :request, requester: @requester
    end

    context 'requester is a requester' do
      context 'request is unassigned' do
        it "should call its requester a requester, independent of its role" do
          request_role(@request, @requester).should eq('Requester')
        end

        it "should use user role attribute for a provider" do
          request_role(@request, @provider).should eq(@provider.role.titleize)
        end

        it "should use user role attribute for an administrator" do
          request_role(@request, @administrator).should eq(@administrator.role.titleize)
        end
      end

      context 'request is assigned to a provider' do
        before(:each) do
          @request.assignee = @provider
        end

        it "should call its requester a requester, independent of its role" do
          request_role(@request, @requester).should eq('Requester')
        end

        it "should use custom role for the assigned provider" do
          request_role(@request, @provider).should eq('Assigned Provider')
        end

        it "should use user role attribute for an administrator" do
          request_role(@request, @administrator).should eq(@administrator.role.titleize)
        end
      end

      context 'request is assigned to an administrator' do
        before(:each) do
          @request.assignee = @administrator
        end

        it "should call its requester a requester, independent of its role" do
          request_role(@request, @requester).should eq('Requester')
        end

        it "should use user role attribute for a provider" do
          request_role(@request, @provider).should eq(@provider.role.titleize)
        end

        it "should use custom role for the assigned administrator" do
          request_role(@request, @administrator).should eq('Assigned Administrator')
        end
      end
    end

    context 'requester is a provider' do
      before(:each) do
        @requester = FactoryGirl.create :user, role: 'provider'
        @request.requester = @requester
      end

      context 'request is unassigned' do
        it "should call its requester a requester, independent of its role" do
          request_role(@request, @requester).should eq('Requester')
        end

        it "should use user role attribute for a provider" do
          request_role(@request, @provider).should eq(@provider.role.titleize)
        end

        it "should use user role attribute for an administrator" do
          request_role(@request, @administrator).should eq(@administrator.role.titleize)
        end
      end

      context 'request is assigned to a provider' do
        before(:each) do
          @request.assignee = @provider
        end

        it "should call its requester a requester, independent of its role" do
          request_role(@request, @requester).should eq('Requester')
        end

        it "should use custom role for the assigned provider" do
          request_role(@request, @provider).should eq('Assigned Provider')
        end

        it "should use user role attribute for an administrator" do
          request_role(@request, @administrator).should eq(@administrator.role.titleize)
        end
      end

      context 'request is assigned to an administrator' do
        before(:each) do
          @request.assignee = @administrator
        end

        it "should use user role attribute for its requester" do
          request_role(@request, @requester).should eq('Requester')
        end

        it "should use user role attribute for a provider" do
          request_role(@request, @provider).should eq(@provider.role.titleize)
        end

        it "should use custom role for the assigned administrator" do
          request_role(@request, @administrator).should eq('Assigned Administrator')
        end
      end
    end

    context 'requester is an administrator' do
      before(:each) do
        @requester = FactoryGirl.create :user, role: 'administrator'
        @request.requester = @requester
      end

      context 'request is unassigned' do
        it "should call its requester a requester, independent of its role" do
          request_role(@request, @requester).should eq('Requester')
        end

        it "should use user role attribute for a provider" do
          request_role(@request, @provider).should eq(@provider.role.titleize)
        end

        it "should use user role attribute for an administrator" do
          request_role(@request, @administrator).should eq(@administrator.role.titleize)
        end
      end

      context 'request is assigned to a provider' do
        before(:each) do
          @request.assignee = @provider
        end

        it "should call its requester a requester, independent of its role" do
          request_role(@request, @requester).should eq('Requester')
        end

        it "should use custom role for the assigned provider" do
          request_role(@request, @provider).should eq('Assigned Provider')
        end

        it "should use user role attribute for an administrator" do
          request_role(@request, @administrator).should eq(@administrator.role.titleize)
        end
      end

      context 'request is assigned to an administrator' do
        before(:each) do
          @request.assignee = @administrator
        end

        it "should call its requester a requester, independent of its role" do
          request_role(@request, @requester).should eq('Requester')
        end

        it "should use user role attribute for a provider" do
          request_role(@request, @provider).should eq(@provider.role.titleize)
        end

        it "should use custom role for the assigned administrator" do
          request_role(@request, @administrator).should eq('Assigned Administrator')
        end
      end
    end
  end
end
