class TagsController < ApplicationController
  def index
  end

  def suggest
    if params[:q].present?
      @tag_slugs = Tag.where('slug ilike ?', "#{params[:q]}%").limit(20).pluck(:slug)
    elsif params[:star_id].present?
      star = Star.find params[:star_id]
      @tag_slugs = Star.suggested_tag_slugs(star.repo_id, exclude_tags: star.tags.pluck(:slug))
    end
  end
end
