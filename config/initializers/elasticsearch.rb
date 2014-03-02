Kaminari::Hooks.init

module Elasticsearch::Model::Response::Pagination::Kaminari
  def limit_value
    search.definition[:size] || 0
  end

  def offset_value
    search.definition[:from] || 0
  end
end

Elasticsearch::Model::Response::Response.__send__ :include, Elasticsearch::Model::Response::Pagination::Kaminari
