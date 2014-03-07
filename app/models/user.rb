class User < ActiveRecord::Base
  STARS_SYNC_PERIOD = 30.minutes

  has_many :stars, dependent: :destroy
  after_create :collect_stars_async


  def self.from_omniauth(oauth)
    return unless oauth['provider'] == 'github'
    find_or_initialize_by(uid: oauth['uid']).tap do |user|
      user.name =  oauth['info']['name']
      user.email = oauth['info']['email']
      user.token = oauth['credentials']['token']
      user.save
    end
  end

  def time_to_repeat_collect_stars
    stars_updated_at.present? && stars_updated_at + STARS_SYNC_PERIOD - Time.current
  end

  def can_update_stars?
    time_to_repeat_collect_stars.try :<, 0
  end

  def repeat_collect_stars_async
    collect_stars_async if can_update_stars?
  end

  def collect_stars_async
    update stars_updated_at: nil
    GetStarsWorker.perform_async(id)
  end

  def collect_stars
    current_stars, new_stars = client.starred.map{ |data| stars.find_or_initialize_from_github(data) }.partition(&:persisted?)
    old_star_ids = stars.where.not(id: current_stars.map(&:id)).ids

    current_stars.each{ |star| star.update(unstarred: false) if star.unstarred? }
    self.stars << new_stars
    Star.where(id: old_star_ids).each{ |star| star.update unstarred: true, created_at: Time.current }
  end

  def client
    @client ||= Octokit::Client.new access_token: token, auto_paginate: true
  end
end
