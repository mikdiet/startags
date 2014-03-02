class StarsController < ApplicationController
  before_action :authenticate_user!

  def index
    @stars = Star.tagged_search(current_user.id).page(params[:page]).records
  end
end
