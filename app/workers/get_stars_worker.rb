class GetStarsWorker
  include Sidekiq::Worker

  def perform(user_id)
    User.find(user_id).collect_stars
  end
end
