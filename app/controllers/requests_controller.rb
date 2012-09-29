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
      render 'new'
    end
  end

  def index
    @requests = current_user.requests
  end

  def show
    @request = current_user.requests.find params[:id]
  end

  def edit
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
