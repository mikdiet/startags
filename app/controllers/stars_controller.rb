class StarsController < ApplicationController
  before_action :authenticate_user!

  def index
    @stars_responce = Star.tagged_search(current_user.id).page(params[:page])
    @stars = @stars_responce.records
    @tags = @stars_responce.response['facets']['tag_slugs']['terms']
  end
end
