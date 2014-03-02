class Star < ActiveRecord::Base
  include Searchable

  belongs_to :user
  belongs_to :repo
  has_and_belongs_to_many :tags

  scope :starred, ->{ where unstarred: false }
  scope :unstarred, ->{ where unstarred: true }

  def self.find_or_initialize_from_github(data)
    repo = Repo.find_or_create_by(name: data.full_name)
    repo.update description: data.description
    find_or_initialize_by repo: repo
  end
end
