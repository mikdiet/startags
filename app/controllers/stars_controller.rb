class StarsController < ApplicationController
  before_action :authenticate_user!

  def index
    @stars = current_user.stars.includes(:repo, :tags).page(params[:page]).per(100)
  end
end
