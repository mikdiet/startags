json.array! @tags do |tag|
  json.id tag.slug
  json.text tag.slug
end
