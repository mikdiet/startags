module Star::Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model

    mapping do
      # ...
    end
  end

  module ClassMethods
    def search(query)
      # ...
    end
  end
end
