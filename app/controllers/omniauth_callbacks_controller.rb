class OmniauthCallbacksController < ApplicationController
  def all
    #raise request.env["omniauth.auth"].to_yaml
    user = User.from_omniauth(request.env["omniauth.auth"])
    if user_signed_in?
      if user
        redirect_to :root and return
      else
        current_user.authentications.create(provider: request.env['omniauth.auth']['provider'], user_id: current_user.id, uuid: request.env['omniauth.auth']['uid'])
        redirect_to :root and return
      end
    else
      if user
        sign_in user
        redirect_to :root and return
      else
        flash[:alert] = "Cannot sign in with #{request.env['omniauth.auth']['provider']}"
        redirect_to :auth and return
      end
    end
  end

  def failure
    flash[:alert] = "Cannot sign in with #{request.env["PATH_INFO"].split('/')[3]}"
    redirect_to :auth
  end
  alias_method :twitter, :all
  alias_method :facebook, :all
  alias_method :vkontakte, :all
  alias_method :google_oauth2, :all
  alias_method :yandex, :all
end
