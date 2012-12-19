class CommentsController < ApplicationController
  load_and_authorize_resource :request
  load_and_authorize_resource :comment, through: :request

  def create
    request = Request.find params[:request_id]

    # Create the comment, associating it with the request.
    @comment = request.comments.new
    @comment.content = params[:comment][:content]

    # Associate the comment with the current user.
    @comment.user = current_user

    unless @comment.save
      flash[:error] = "We were unable to create the comment."
    end

    redirect_to request 
  end
end
