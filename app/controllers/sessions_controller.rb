class SessionsController < ApplicationController
  #before_action :inspect_auth, only: :create

  def create
    user = User.from_omniauth request.env['omniauth.auth']
    user.repeat_collect_stars_async
    session[:user_id] = user.id
    redirect_to stars_url, notice: "Welcome, #{user.name}"
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: "Hope to see you later"
  end

private
  def inspect_auth
    render html: view_context.debug(request.env['omniauth.auth'])
  end
end
