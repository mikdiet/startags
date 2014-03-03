module ApplicationHelper
  def list_item_for_tag(tag, &block)
    if current_tags.include?(tag)
      tags = current_tags.dup.delete(tag).to_a
      path = tags.empty? ? stars_path : tagged_stars_path(tags: tags)
      li_class = 'active'
    else
      path = tagged_stars_path(tags: current_tags.dup.add(tag).to_a)
      li_class = nil
    end
      
    content_tag 'li', link_to(path, &block), class: li_class
  end
end
