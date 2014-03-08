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
    current_stars = client.starred.map{ |data| stars.find_or_initialize_from_github(data) }.reverse
    old_star_ids = stars.where.not(id: current_stars.map(&:id).compact).ids
    pos = stars.maximum(:position) || 0

    current_stars.each do |star|
      if star.new_record?
        pos += 1
        star.position = pos
        self.stars << star
      elsif star.unstarred?
        pos += 1
        star.update(unstarred: false, position: pos)
      end
    end

    Star.where(id: old_star_ids).each{ |star| star.update unstarred: true }
  end

  def client
    @client ||= Octokit::Client.new access_token: token, auto_paginate: true
  end
end
