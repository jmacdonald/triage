class AttachmentsController < ApplicationController
  load_and_authorize_resource

  def create
    request = Request.find params[:request_id]
    @attachment = request.attachments.new params[:attachment]
    @attachment.user = current_user

    unless @attachment.save
      flash[:error] = 'Attachment upload failed; please try again.'
    end

    redirect_to request 
  end

  def destroy
    request = Request.find params[:request_id]
    attachment = Attachment.find params[:id]

    unless attachment.destroy
      flash[:error] = 'Attachment delete failed; please try again.'
    end

    redirect_to request 
  end
end
