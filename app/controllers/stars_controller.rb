class StarsController < ApplicationController
  before_action :authenticate_user!

  def index
    @stars_responce = Star.tagged_search(current_user.id, tags: current_tags, untagged: params[:untagged]).page(params[:page])
    @stars = @stars_responce.records
    @tags = @stars_responce.response['facets']['tag_slugs']['terms']
  end

  def update_all
    if current_user.repeat_collect_stars_async
      render json: 'OK'
    else
      render json: current_user.time_to_repeat_collect_stars
    end
  end

private
  helper_method :current_tags
  def current_tags
    @current_tags ||= Set.new params[:tags].try :split, '/'
  end
end
