class RequestsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource

  def new
    @request = current_user.requests.new
  end

  def create
    @request = current_user.requests.new params[:request]
    
    if @request.save
      redirect_to @request
    else
      flash[:error] = 'We were unable to create your request. Please try again.'
      render 'new'
    end
  end

  def index
    @requests = Request.page params[:page]
  end

  def open
    @requests = current_user.requests.unclosed.page params[:page]
  end

  def closed
    @requests = current_user.requests.closed.page params[:page]
  end

  def unassigned
    @requests = Request.unassigned.page params[:page]
  end

  def open_assignments
    @requests = current_user.assignments.unclosed.page params[:page]
  end

  def closed_assignments
    @requests = current_user.assignments.closed.page params[:page]
  end

  def show
    @request = Request.find params[:id]
  end

  def update
    @request = Request.find params[:id]

    unless @request.update_attributes params[:request]
      flash[:error] = @request.errors.full_messages.join('<br />').html_safe
    end

    redirect_to @request
  end

  def destroy
    @request = Request.find params[:id]

    if @request.destroy
      redirect_to requests_url
    end
  end

  def search
    begin
      # If a valid request ID is specified, show the request.
      request = Request.find params[:request_id]
      redirect_to request
    rescue ActiveRecord::RecordNotFound
      # Couldn't find an exact match for the request id; bail.
      @requests = []
    end
  end
end
