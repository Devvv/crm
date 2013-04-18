class ApplicationController < ActionController::Base
  protect_from_forgery

  def get_companies
    if user_signed_in?
      if current_user.active.to_i != 1
        redirect_to :auth and return
      end
      if params[:c].to_i > 0
        current_user.update_attribute :last_company, params[:c]
        redirect_to :root and return
      end
      @companies = current_user.companies
      if @companies
        cids = @companies.map {|c| c.id.to_i}
        if current_user.last_company.to_i > 0
          c_id = current_user.last_company.to_i
        else
          c_id = @companies.first.id
          current_user.update_attribute :last_company, c_id
        end
        if c_id.in? cids
          @company = @companies.find(c_id)
        else
          @company = @companies.first
          current_user.update_attribute :last_company, c_id
        end
        @connection = current_user.user_companies.where("user_companies.company_id = ?", @company.id).first
      else
        redirect_to :profile and return
      end
    end
  end

  def signed_in
    if user_signed_in?
      if current_user.active.to_i != 1
        redirect_to :auth and return
      end
    else
      redirect_to :auth and return
    end
  end

  def reg
    if user_signed_in?
      redirect_to :root and return
    else
      if params[:user]
        if params[:user][:email].match(/^[+a-z0-9_.-]+@[a-z0-9.-]+\.[a-z]{2,6}$/i)
          if User.where(:email => params[:user][:email]).exists?
            flash.now[:alert] = t(:user_already_registered)
          else
            code = Digest::SHA1.hexdigest(Time.now.to_s)
            cr = 1 # params[:cr] ? params[:cr].to_i : 0
            pass = ('a'..'z').to_a.shuffle.first(6).join
            Notify.registration(params[:user][:email], pass, code, cr).deliver
            user = User.create({
                                   :email => params[:user][:email],
                                   :password => pass,
                                   :active => 0
                               })
            Invite.create({
                              :user_from => 0,
                              :user_to => user.id,
                              :to => params[:user][:email],
                              :code => code,
                              :company_id => 0,
                              :expire => 1.month.from_now,
                              :cr => cr
                          })
            render :reg_success, :layout => false and return
          end
        else
          flash.now[:alert] = t(:wrong_format_email)
        end
      end
    end
    render :reg, :layout => false
  end

  def forget
    if user_signed_in?
      redirect_to :root and return
    else
      if params[:user]
        if params[:user][:email].match(/^[+a-z0-9_.-]+@[a-z0-9.-]+\.[a-z]{2,6}$/i)
          if User.where(:email => params[:user][:email]).exists?
            pass = ('a'..'z').to_a.shuffle.first(6).join
            Notify.forget(params[:user][:email], pass).deliver
            user = User.find_by_email(params[:user][:email])
            user.update_attribute :password, pass
            render :reg_success, :layout => false and return
          else
            flash.now[:alert] = t(:user_not_registered)
          end
        else
          flash.now[:alert] = t(:wrong_format_email)
        end
      end
    end
    render :forget, :layout => false
  end

  def auth
    if params[:i]
      inv = Invite.find_by_code(params[:i])
      if inv
        if inv.cr.to_i == 1
          u = User.find_by_email(inv.to)
          if u && u.active.to_i != 1
            u.update_attribute :active, 1
            company = Company.create({
                                         :name => u.email.to_s + " & company",
                                         :user_id => u.id
                                     })
            UserCompany.where({access: 2, company_id: company.id, user_id: u.id}).first_or_create
            sign_in u
            inv.update_attribute :activated, 1
            redirect_to :root and return
          else
            flash.now[:alert] = t(:wrong_invite_code)
          end
        else
          u = User.find_by_email(inv.to)
          if u
            if u.active.to_i != 1
              u.update_attribute :active, 1
            end
            sign_in u
            inv.update_attribute :activated, 1
            UserCompany.where({access: 0, company_id: inv.company_id, user_id: u.id}).first_or_create
            redirect_to :root and return
          else
            pass = ('a'..'z').to_a.shuffle.first(6).join
            Notify.registr(inv.to, pass).deliver
            u = User.create({
              :email => inv.to,
              :password => pass,
              :active => 1
            })
            sign_in u
            inv.update_attribute :activated, 1
            UserCompany.where({access: 0, company_id: inv.company_id, user_id: u.id}).first_or_create
            redirect_to :root and return
          end
        end
      end
    end
    if user_signed_in?
      if current_user.active.to_i != 1
        flash.now[:alert] = t(:unactive_user)
      else
        if params[:i]
          inv = Invite.find_by_code(params[:i])
          if inv
            if inv.company_id.to_i > 0 && inv.to == current_user.email && inv.activated.to_i != 1
              inv.update_attribute(:activated, 1)
              UserCompany.where({access: 0, company_id: inv.company_id, user_id: current_user.id}).first_or_create
              redirect_to :root and return
            end
            if inv.cr.to_i == 1
              user = User.find_by_email(inv.to)
              if user
                if user.email != current_user.email
                  sign_out
                  sign_in user
                end
                user.update_attributes :active, 1
                company = Company.create({
                                             :name => user.email.to_s + " & company",
                                             :user_id => user.id
                                         })
                UserCompany.where({access: 2, company_id: company.id, user_id: user.id}).first_or_create
              else
                flash.now[:alert] = t(:wrong_invite_code)
              end
            end
          else
            flash.now[:alert] = t(:wrong_invite_code)
          end
        end
      end
    else
      if params[:user]
        if params[:user][:email].match(/^[+a-z0-9_.-]+@[a-z0-9.-]+\.[a-z]{2,6}$/i) && params[:user][:password].length > 5
          user = User.find_by_email(params[:user][:email])
          if user
            if user.active.to_i != 1
              flash.now[:alert] = t(:unactive_user)
            else
              if user.valid_password?(params[:user][:password])
                #if params[:invite]
                #  inv = Invite.find_by_code(params[:invite])
                #  if inv && inv.to == params[:user][:email] && inv.activated.to_i != 1
                #    if inv.cr.to_i == 1
                #      u = User.find_by_email(inv.to)
                #      if u
                #        u.update_attributes :active, 1
                #        company = Company.create({
                #                                     :name => u.email.to_s + "'s company",
                #                                     :user_id => u.id
                #                                 })
                #        UserCompany.where({access: 2, company_id: company.id, user_id: u.id}).first_or_create
                #        sign_in u
                #        redirect_to :root and return
                #      else
                #        flash.now[:alert] = t(:wrong_invite_code)
                #      end
                #    else
                #      UserCompany.where({access: 0, company_id: inv.company_id, user_id: user.id}).first_or_create
                #    end
                #  end
                #end
                sign_in user
                redirect_to :root and return
              else
                flash.now[:alert] = t(:wrong_email_or_password)
              end
            end
          else
            flash.now[:alert] = t(:wrong_email_or_password)
            #user = User.create(:email => params[:user][:email], :password => params[:user][:password])
            #if params[:invite]
            #  inv = Invite.find_by_code(params[:invite])
            #  if inv && inv.to == params[:user][:email] && inv.activated.to_i != 1
            #    UserCompany.where({access: 0, company_id: inv.company_id, user_id: user.id}).first_or_create
            #  end
            #end
            #sign_in user
            #redirect_to :root and return
          end
        else
          flash.now[:alert] = t(:enter_email_and_password)
        end
      end
    end
    @imail = ''
    if params[:i] && !user_signed_in?
      i = Invite.find_by_code(params[:i])
      if i && i.activated.to_i != 1
        @imail = i.to
      end
    end
    render :auth, :layout => false
  end

  def out
    if user_signed_in?
      sign_out current_user
    end
    redirect_to :auth
  end

  def create_company
    if user_signed_in?
      if params[:company]
        if params[:company][:name].length > 2
          if Company.where(:code => params[:company][:code]).exists?
            flash.now[:alert] = t(:company_code_already_exists)
          else
            company = Company.new(params[:company])
            company.user_id = current_user.id
            if company.save
              connection = UserCompany.new({:user_id => current_user.id, :company_id => company.id, :access => 2})
              if connection.save
                redirect_to :root and return
              end
            end
          end
        else
          flash.now[:alert] = t(:company_name_too_small)
        end
      end
    else
      redirect_to :auth and return
    end
    render :create_company, :layout => false
  end

end
