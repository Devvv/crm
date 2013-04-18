class DownloadController < ApplicationController

  def file
    if params[:id].to_i > 0 and UploadFile.where(:id => params[:id]).exists? and user_signed_in?
      file = UploadFile.find(params[:id])
      if current_user.last_company == file.company_id
        send_file file.file.path and return
      end
    end
    render :text => "Access denied"
  end

end