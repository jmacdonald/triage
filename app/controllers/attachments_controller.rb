class AttachmentsController < ApplicationController
  load_and_authorize_resource :request
  load_and_authorize_resource :attachment, through: :request

  def create
    request = Request.find params[:request_id]
    @attachment = request.attachments.new attachment_params
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

  def attachment_params
    params.require(:attachment).permit(:title, :file)
  end
end
