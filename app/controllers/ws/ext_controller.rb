# encoding: utf-8
include ActionView::Helpers::NumberHelper
class Ws::ExtController < WsController

  def get_users
    result = {:stat => "empty", :data => []}
    if message[:name]
      name = '%' + message[:name] + '%'
      company = Company.find(message[:company_id]).users.pluck("users.id")
      users = User.where("id NOT IN (:ids) AND (vacancy LIKE :name OR name LIKE :name OR surname LIKE :name OR subname LIKE :name OR email LIKE :name)", ids:company, name:name).order("rating desc")
      if users.exists?
        users.each do |u|
          u[:full_name] = u.get_name
          u[:photo_path] = u.photo(:thumb)
          if u.vacancy.blank?
            u[:appointment] = t(:no_posts)
          else
            u[:appointment] = u.vacancy
          end
        end
        result[:stat] = "success"
        result[:data] = users
      end
    end
    trigger_success result
  end

  def add_invite
    params = message
    @company = Company.find(params[:company_id])
    @connection = UserCompany.where(company_id: @company.id, user_id: current_user.id).first
    result = {}
    if !params[:email].match(/^[+a-z0-9_.-]+@[a-z0-9.-]+\.[a-z]{2,6}$/i).nil? && @company && @connection.access >= 2
      if Invite.where({:company_id => @company.id, :to => params[:email], :activated => 0}).where("expire > ?", Time.now).exists?
        result = {:stat => 'error', :data => t(:invite_already_sended)}
      else
        code = Digest::SHA1.hexdigest(Time.now.to_s)
        if User.where(:email => params[:email]).exists?
          #Notify.invite(current_user, params[:email], @company, code).deliver
        else
          pass = ('a'..'Z').to_a.shuffle.first(6).join
          user = User.create({
                                 :email => params[:email],
                                 :password => pass,
                                 :active => 0
                             })
        end
        if Notify.invite(current_user, params[:email], @company, code).deliver
          Invite.create({
                            :user_from => current_user.id,
                            :user_to => user ? user.id : 0,
                            :to => params[:email],
                            :code => code,
                            :company_id => @company.id,
                            :expire => 1.month.from_now,
                            :cr => 0
                        })
          result = {stat: 'success', data: t(:invite_send_success)}
        else
          result = {stat: 'error', data: t(:invite_send_error)}
        end
      end
    else
      result = {stat: 'error', data: t(:invite_send_error)}
    end
    trigger_success result
  end

  def delete_file
    if message[:id].to_i > 0
      company = Company.find(current_user.last_company)
      file = UploadFile.find(message[:id])
      h = History.create({company_id: company.id, feed_id: file.feed_id, type_id: 4, user_id: current_user.id, text: file.name})
      WebsocketRails["company_#{company.id}"].trigger(:add_history, h)
      if file && file.destroy
        #count = company.store_count - size
        #count = count < 0 ? 0 : count
        #company.update_attribute :store_count, count
        WebsocketRails["company_#{company.id}"].trigger(:delete_feed_file, {:id => message[:id]})
        #render json: { :stat => "success", :data => params[:id] }
      else
        #render json: { :stat => "error", :data => "error deleting file" }
      end
    end
  end

  def upload

    mess = message[:mess]

    company = Company.find(current_user.last_company)

    if message[:size].to_i + company.store_count.to_i > company.store_limit.to_i
      dt = {:stat => "error", :data => "Превышен лимит дискового пространства компании" }
      trigger_failure dt and return
    end

    if message[:ind].to_i == 0
      mode = "wb"
    else
      mode = "ab"
    end
    file = File.new('tmp/' + message[:name], mode)
    file.write(Base64.decode64(mess))
    file.close()

    data = {:ind => message[:ind]}

    if message[:ind] == message[:size]

      file = File.open('tmp/' + message[:name])

      if message[:user_id].to_i > 0

        current_user.photo = file
        if current_user.save
          WebsocketRails["company_#{company.id}"].trigger(:update_user_photo, {:id => current_user.id, :photo_path_medium => current_user.photo(:medium), :photo_path_thumb => current_user.photo(:thumb)})
          file.close()
          File.delete('tmp/' + message[:name])
        end

      else

        upload_file = UploadFile.new

        upload_file.file = file

        upload_file.name = message[:name]
        upload_file.user_id = current_user.id
        upload_file.company_id = company.id
        if message[:history_id]
          upload_file.history_id = message[:history_id]
        end
        if message[:feed_id]
          upload_file.feed_id = message[:feed_id]
        end

        #render json: {up: @upload_file, rf: @raw_file}
        if upload_file.save
          h = History.create({company_id: company.id, feed_id: upload_file.feed_id, type_id: 3, user_id: current_user.id, text: upload_file.name})
          WebsocketRails["company_#{company.id}"].trigger(:add_history, h)
          count = company.store_count + message[:size].to_i
          count = count < 0 ? 0 : count
          #@company.update_attribute :store_count, @company.store_count + file.tempfile.size
          upload_file[:path] = upload_file.file.url
          WebsocketRails["company_#{company.id}"].trigger(:upload_file, upload_file)
          file.close()
          File.delete('tmp/' + upload_file.name)
        end
      end

    end

    trigger_success data

  end

  def cancel_upload

    if message[:name]
      if File.exist?('tmp/' + message[:name])
        File.delete('tmp/' + message[:name])
      end
    end

  end

  def payment
    if message[:type].to_i >= 0 and user_signed_in? and current_user.last_company
      resp = {}
      type = message[:type].to_i
      company = Company.find(current_user.last_company)

      if company.type_id.to_i == type
        resp[:success] = false
        resp[:message] = "Error"
        return trigger_success resp
      end

      if type == 0
        resp[:success] = false
        resp[:message] = "Free"
        return trigger_success resp
      end

      case type
        when 1
          bill = Payment.create({user_id: current_user.id, company_id: company.id, amount: 1500, paid: 0, plan: 1 })
          resp[:success] = true
          resp[:message] = "Payment"
          resp[:price] = 1500
          resp[:bill] = bill.id
          resp[:signature] = Digest::MD5.hexdigest("beweek.ru:1500:#{bill.id}:beweek888lll")
        when 2
          bill = Payment.create({user_id: current_user.id, company_id: company.id, amount: 3000, paid: 0, plan: 2 })
          resp[:success] = true
          resp[:message] = "Payment"
          resp[:price] = 3000
          resp[:bill] = bill.id
          resp[:signature] = Digest::MD5.hexdigest("beweek.ru:3000:#{bill.id}:beweek888lll")
        else
          resp[:success] = false
          resp[:message] = "Parameters error"
      end

      trigger_success resp

    end
    render :nothing => true
  end


=begin
  def upload
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
      History.create({company_id: @company.id, feed_id: upload_file.feed_id, type_id: 3, user_id: current_user.id, text: upload_file.name})
      count = @company.store_count + file.tempfile.size
      count = count < 0 ? 0 : count
      #@company.update_attribute :store_count, @company.store_count + file.tempfile.size
      upload_file[:path] = upload_file.file.url
      render json: { :stat => "success", :data => upload_file, :count => number_to_human_size(count, {:locale => :en}) }
    else
      render json: { :stat => "error", :data => "error saving file" }
    end
  end
=end

end