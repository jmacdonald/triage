class RequestsController < ApplicationController
  before_filter :authenticate_user!

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
    @requests = Request.all
  end

  def open
    @requests = current_user.requests.unclosed
  end

  def closed
    @requests = current_user.requests.closed
  end

  def open_assignments
    @requests = current_user.assignments.unclosed
  end

  def closed_assignments
    @requests = current_user.assignments.closed
  end

  def show
    @request = current_user.requests.find params[:id]
  end

  def update
    @request = current_user.requests.find params[:id]

    if @request.update_attributes params[:request]
      redirect_to @request
    else
      render 'edit'
    end
  end

  def destroy
    @request = current_user.requests.find params[:id]

    if @request.destroy
      redirect_to requests_url
    end
  end
end
