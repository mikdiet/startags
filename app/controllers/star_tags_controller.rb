class StarTagsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_star, :load_tag

  def create
    @star.tags << @tag
    @star.touch
    render json: 'ok'
  end

  def destroy
    @star.tags.delete @tag
    @star.touch
    render json: 'ok'
  end

private
  def load_star
    @star = current_user.stars.find(params[:star_id])
  end

  def load_tag
    @tag = Tag.find_or_create_by(slug: params[:slug])
  end
end
