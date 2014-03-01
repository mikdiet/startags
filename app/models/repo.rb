class Repo < ActiveRecord::Base
  has_many :stars, dependent: :destroy

  validates :name, presence: true
end
