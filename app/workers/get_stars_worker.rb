class GetStarsWorker
  include Sidekiq::Worker

  def perform(user_id)
    user = User.find(user_id)
    user.collect_stars
    user.update stars_updated_at: Time.current
  end
end
