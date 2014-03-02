class TagsController < ApplicationController
  def index
  end

  def suggest
    @tags = Tag.limit(20)
    if params[:q].present?
      @tags = @tags.where('slug ilike ?', "#{params[:q]}%")
    end
  end
end
