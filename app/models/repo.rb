class Repo < ActiveRecord::Base
  has_many :stars, dependent: :destroy
end
