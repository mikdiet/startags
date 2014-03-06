module Star::Searchable
  extend ActiveSupport::Concern

  included do
    paginates_per 100
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    mapping do
      indexes :tag_slugs, index: 'not_analyzed'
      indexes :repo_name
    end

    after_touch() { __elasticsearch__.index_document }
  end

  module ClassMethods
    def tagged_search(user_id, tags: [], q: nil, untagged: false)

      query = Jbuilder.encode do |j|
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
                {term: {unstarred: false}},
                tags.present? ? {terms: {tag_slugs: tags, execution: 'and'}} : nil
              ].compact
            end
          end # filtered
        end

        if untagged
          j.filter missing: {field: 'tag_slugs'}
        end

        j.sort [{created_at: 'desc'}]

        j.facets do
          j.tag_slugs do
            j.terms do
              j.field :tag_slugs
              j.size 1000
            end
          end
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
