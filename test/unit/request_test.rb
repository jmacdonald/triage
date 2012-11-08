require 'test_helper'

class RequestTest < ActiveSupport::TestCase
  subject { requests :valid }

  should belong_to :requester
  should belong_to :assignee
  should belong_to :status
  should belong_to :system
  should have_many :comments
  should have_many :attachments
  should validate_presence_of :title
  should validate_presence_of :description
  should validate_presence_of :requester
  should validate_presence_of :system
  should validate_presence_of :severity
  should ensure_inclusion_of(:severity).in_array %w(minor moderate major critical)

  [:assignee_id, :status_id, :system_id, :title, :description, :severity, :requester_id].each do |attribute|
    should allow_mass_assignment_of(attribute)
  end

  test 'that requests can display themselves as strings' do
    request = requests :valid
    assert_equal "Request ##{request.id}: #{request.title}", requests(:valid).to_s
  end

  test 'that request status defaults to default status' do
    request = requests :valid
    request.status = nil
    
    assert request.save, 'nil status caused save to fail'
    assert_equal statuses(:valid), request.status
  end

  test "that the default status doesn't override a pre-existing one" do
    request = requests :valid
    request.status = statuses :closed
    request.save

    assert_equal statuses(:closed), request.status
  end

  test 'that the closed scope only returns requests with a status that is closed' do
    Request.closed.each do |request|
      assert request.status.closed?
    end
  end

  test 'that the unclosed scope only returns requests with a status that is not closed' do
    Request.unclosed.each do |request|
      assert_false request.status.closed?
    end
  end

  test 'that the unassigned scope only returns requests without an assignee' do
    Request.unassigned.each do |request|
      assert request.assignee.nil?
    end
  end

  test 'that a new request assigns itself to the next user responsible for its system' do
    request = Request.new({
      title: 'test',
      description: 'test',
      requester_id: users(:valid).id,
      status_id: statuses(:valid).id,
      system_id: systems(:valid).id,
      severity: 'moderate'
    })
    request.save

    assert_equal users(:valid), request.assignee
  end

  context 'assignee association' do
    setup do
      @request = requests :valid
    end

    should 'allow administrators to be associated' do
      @request.assignee = users :administrator
      @request.save
  
      # Need to reload the value from the db.
      assert Request.find(@request.id).assignee
    end

    should 'allow providers to be associated' do
      @request.assignee = users :provider
      @request.save

      # Need to reload the value from the db.
      assert Request.find(@request.id).assignee
    end

    should 'not allow requesters to be associated' do
      @request.assignee = users :requester
      @request.save

      # Need to reload the value from the db.
      assert_nil Request.find(@request.id).assignee
    end
  end
end
