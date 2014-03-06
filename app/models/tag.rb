class Tag < ActiveRecord::Base
  has_and_belongs_to_many :stars

  validates :slug, format: {with: /\A[-_\+\.#a-z0-9]+\z/i }
end
