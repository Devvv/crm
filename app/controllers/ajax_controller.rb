class AjaxController < ApplicationController
  layout false
  before_filter :signed_in, :get_companies

  def upload
    if params[:file]
      upload_file = UploadFile.new

      file = params[:file]

      upload_file.file = file
      if file.tempfile.size + @company.store_count > @company.store_limit
        render json: { :stat => "error", :data => "store limit is exceeded" } and return
      end
      upload_file.name = upload_file.file.original_filename
      upload_file.user_id = current_user.id
      upload_file.company_id = @company.id
      if params[:history_id]
        upload_file.history_id = params[:history_id]
      end
      if params[:feed_id]
        upload_file.feed_id = params[:feed_id]
      end

      #render json: {up: @upload_file, rf: @raw_file}
      if upload_file.save
        h = History.create({company_id: @company.id, feed_id: upload_file.feed_id, type_id: 3, user_id: current_user.id, text: upload_file.name})
        WebsocketRails["company_#{@company.id}"].trigger(:add_history, h)
        count = @company.store_count + file.tempfile.size
        count = count < 0 ? 0 : count
        #@company.update_attribute :store_count, @company.store_count + file.tempfile.size
        upload_file[:path] = upload_file.file.url
        WebsocketRails["company_#{@company.id}"].trigger(:upload_file, upload_file)
        render json: { :stat => "success", :data => upload_file }
      else
        render json: { :stat => "error", :data => "error saving file" }
      end
    else
      render :nothing => true
    end
  end

  def file_del
    if params[:id]
      file = UploadFile.find(params[:id])
      size = file.file_file_size
      h = History.create({company_id: @company.id, feed_id: file.feed_id, type_id: 4, user_id: current_user.id, text: file.name})
      WebsocketRails["company_#{@company.id}"].trigger(:add_history, h)
      if file && file.destroy
        count = @company.store_count - size
        count = count < 0 ? 0 : count
        #@company.update_attribute :store_count, count
        WebsocketRails["company_#{@company.id}"].trigger(:delete_file, {:id => params[:id]})
        render json: { :stat => "success", :data => params[:id] }
      else
        render json: { :stat => "error", :data => "error deleting file" }
      end
    end
  end

  def user_photo
    if params[:user]
      current_user.photo = params[:user][:photo]
      if current_user.save
        WebsocketRails["company_#{@company.id}"].trigger(:update_user_photo, {:id => current_user.id, :photo_path_medium => current_user.photo(:medium), :photo_path_thumb => current_user.photo(:thumb)})
        render json: {success: true}
      else
        render json: {success: false}
      end
    else
      render :nothing => true
    end
  end

  def user_pass
    if params[:user]
      @user = User.find(current_user.id)
      if @user.valid_password?(params[:user][:old_password])
        if params[:user][:password] == params[:user][:password_confirmation]
          if @user.update_attributes params[:user]
            sign_in @user, :bypass => true
            Notify.change_pass(current_user.email, params[:user][:password]).deliver
            render json: {success: true, error: 0}
          else
            render json: {success: false, error: 3}
          end
        else
          render json: {success: false, error: 2}
        end
      else
        render json: {success: false, error: 1}
      end
    else
      render :nothing => true
    end
  end

  def social_links

  end

end