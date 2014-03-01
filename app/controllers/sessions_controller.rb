class SessionsController < ApplicationController
  before_action :inspect_auth, only: :create
  def new
  end

  def create
    user = User.from_omniauth request.env['omniauth.auth']
    session[:user_id] = user.id
    redirect_to root_url, notice: "Welcome, #{user.name}"
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: "See you"
  end

private
  def inspect_auth
    render html: view_context.debug(request.env['omniauth.auth'])
  end
end
