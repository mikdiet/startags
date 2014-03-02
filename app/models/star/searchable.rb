module Star::Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    after_touch() { __elasticsearch__.index_document }
  end

  module ClassMethods
    def tagged_search(user_id, tags: [], q: nil, page: 1, per: 100)
      page = 1 unless page.present? && page.is_a?(Fixnum) && page > 0

      query = Jbuilder.encode do |j|
        j.size per
        j.from (page - 1) * per

        j.query do
          j.filtered do
            if q.present?
              j.query do
                j.match do
                  j.repo_name q
                end
              end
            end

            j.filter do
              j.and [
                {term: {user_id: user_id}},
                tags.present? ? {terms: {tag_slugs: tags, execution: 'and'}} : nil
              ].compact
            end
          end # filtered
        end
      end

      search query
    end

    def eager_import
      includes(:tags, :repo).import
    end
  end

  def as_indexed_json(options = {})
    as_json(
      methods: %i(tag_slugs repo_name)
    )
  end

  def tag_slugs
    tags.map(&:slug)
  end

  def repo_name
    repo.name
  end
end
